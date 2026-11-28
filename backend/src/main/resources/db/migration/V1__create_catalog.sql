CREATE TABLE categories (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_categories_slug UNIQUE (slug)
);

CREATE TABLE courses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    category_id UUID NOT NULL REFERENCES categories (id),
    title VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL,
    description TEXT,
    syllabus_text TEXT,
    type VARCHAR(16) NOT NULL,
    price NUMERIC(19, 2) NOT NULL,
    thumbnail_object_key TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_courses_slug UNIQUE (slug),
    CONSTRAINT ck_courses_type_price CHECK (
        (type = 'FREE' AND price = 0) OR (type = 'PAID' AND price > 0)
    )
);

CREATE INDEX idx_courses_category_id ON courses (category_id);

CREATE TABLE course_videos (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_id UUID NOT NULL REFERENCES courses (id),
    title VARCHAR(255) NOT NULL,
    object_key TEXT NOT NULL,
    original_name TEXT NOT NULL,
    content_type VARCHAR(255) NOT NULL,
    size_bytes BIGINT NOT NULL,
    position INTEGER NOT NULL,
    recorded_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_course_videos_course_position UNIQUE (course_id, position),
    CONSTRAINT ck_course_videos_position CHECK (position >= 0),
    CONSTRAINT ck_course_videos_size CHECK (size_bytes > 0)
);
