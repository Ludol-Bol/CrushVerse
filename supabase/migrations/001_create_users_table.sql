-- =====================================================
-- Миграция: Создание таблицы пользователей (users)
-- Описание: Таблица для хранения профилей пользователей
-- Дата: 2025-10-01
-- =====================================================

-- Создание таблицы users
CREATE TABLE IF NOT EXISTS public.users (
  id UUID REFERENCES auth.users ON DELETE CASCADE PRIMARY KEY,
  nickname VARCHAR(50) UNIQUE NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  icon TEXT,
  birth_date DATE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
  
  -- Ограничения
  CONSTRAINT nickname_min_length CHECK (CHAR_LENGTH(nickname) >= 3),
  CONSTRAINT nickname_max_length CHECK (CHAR_LENGTH(nickname) <= 50),
  CONSTRAINT valid_email CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

-- =====================================================
-- Индексы для улучшения производительности
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_users_nickname ON public.users(nickname);
CREATE INDEX IF NOT EXISTS idx_users_email ON public.users(email);
CREATE INDEX IF NOT EXISTS idx_users_created_at ON public.users(created_at DESC);

-- =====================================================
-- Row Level Security (RLS)
-- =====================================================

-- Включение RLS
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

-- Политика: Все могут просматривать профили пользователей
CREATE POLICY "Пользователи могут просматривать все профили"
  ON public.users
  FOR SELECT
  USING (true);

-- Политика: Пользователи могут создавать только свой профиль
CREATE POLICY "Пользователи могут создавать свой профиль"
  ON public.users
  FOR INSERT
  WITH CHECK (auth.uid() = id);

-- Политика: Пользователи могут обновлять только свой профиль
CREATE POLICY "Пользователи могут обновлять свой профиль"
  ON public.users
  FOR UPDATE
  USING (auth.uid() = id);

-- Политика: Пользователи могут удалять только свой профиль
CREATE POLICY "Пользователи могут удалять свой профиль"
  ON public.users
  FOR DELETE
  USING (auth.uid() = id);

-- =====================================================
-- Функции и триггеры
-- =====================================================

-- Функция для автоматического создания профиля при регистрации
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, nickname, email)
  VALUES (
    NEW.id,
    COALESCE(NEW.raw_user_meta_data->>'nickname', SPLIT_PART(NEW.email, '@', 1)),
    NEW.email
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Триггер для автоматического создания профиля после регистрации
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();

-- =====================================================
-- Комментарии к таблице и столбцам
-- =====================================================

COMMENT ON TABLE public.users IS 'Таблица профилей пользователей';
COMMENT ON COLUMN public.users.id IS 'ID пользователя (связь с auth.users)';
COMMENT ON COLUMN public.users.nickname IS 'Уникальный никнейм пользователя (3-50 символов)';
COMMENT ON COLUMN public.users.email IS 'Электронная почта пользователя';
COMMENT ON COLUMN public.users.icon IS 'URL иконки/аватара пользователя';
COMMENT ON COLUMN public.users.birth_date IS 'Дата рождения пользователя';
COMMENT ON COLUMN public.users.created_at IS 'Дата создания профиля';

