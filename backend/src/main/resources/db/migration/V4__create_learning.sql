CREATE TABLE enrollments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users (id),
    course_id UUID NOT NULL REFERENCES courses (id),
    order_item_id UUID,
    source VARCHAR(16) NOT NULL,
    status VARCHAR(16) NOT NULL,
    enrolled_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    revoked_at TIMESTAMPTZ,

    CONSTRAINT uq_enrollments_user_course UNIQUE (user_id, course_id),
    CONSTRAINT uq_enrollments_order_item UNIQUE (order_item_id),
    CONSTRAINT fk_enrollments_order_item_course FOREIGN KEY (order_item_id, course_id)
        REFERENCES order_items (id, course_id),
    CONSTRAINT ck_enrollments_source_order_item CHECK (
        (source = 'FREE' AND order_item_id IS NULL) OR
        (source = 'PURCHASE' AND order_item_id IS NOT NULL)
    ),
    CONSTRAINT ck_enrollments_status_revoked_at CHECK (
        (status = 'ACTIVE' AND revoked_at IS NULL) OR
        (status = 'REVOKED' AND revoked_at IS NOT NULL)
    )
);

CREATE INDEX idx_enrollments_course_id ON enrollments (course_id);

CREATE TABLE notes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users (id),
    course_video_id UUID NOT NULL REFERENCES course_videos (id),
    timestamp_seconds INTEGER NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT ck_notes_timestamp CHECK (timestamp_seconds >= 0)
);

CREATE INDEX idx_notes_video_user ON notes (course_video_id, user_id);

CREATE TABLE reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users (id),
    course_id UUID NOT NULL REFERENCES courses (id),
    rating INTEGER NOT NULL,
    content TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_reviews_user_course UNIQUE (user_id, course_id),
    CONSTRAINT ck_reviews_rating CHECK (rating BETWEEN 1 AND 5)
);

CREATE INDEX idx_reviews_course_created_at ON reviews (course_id, created_at DESC);
