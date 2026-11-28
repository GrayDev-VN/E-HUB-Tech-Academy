CREATE TABLE course_comments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    course_id UUID NOT NULL REFERENCES courses (id),
    author_id UUID NOT NULL REFERENCES users (id),
    parent_id UUID,
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ,

    CONSTRAINT uq_course_comments_id_course UNIQUE (id, course_id),
    CONSTRAINT fk_course_comments_parent_course FOREIGN KEY (parent_id, course_id)
        REFERENCES course_comments (id, course_id),
    CONSTRAINT ck_course_comments_parent_is_other CHECK (parent_id <> id)
);

CREATE INDEX idx_course_comments_course_created_at ON course_comments (course_id, created_at);
CREATE INDEX idx_course_comments_parent_id ON course_comments (parent_id);

CREATE TABLE forum_topics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL,

    CONSTRAINT uq_forum_topics_slug UNIQUE (slug)
);

CREATE TABLE forum_posts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    topic_id UUID NOT NULL REFERENCES forum_topics (id),
    author_id UUID NOT NULL REFERENCES users (id),
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ
);

CREATE INDEX idx_forum_posts_topic_created_at ON forum_posts (topic_id, created_at DESC);

CREATE TABLE forum_replies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    post_id UUID NOT NULL REFERENCES forum_posts (id),
    author_id UUID NOT NULL REFERENCES users (id),
    content TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMPTZ
);

CREATE INDEX idx_forum_replies_post_created_at ON forum_replies (post_id, created_at);

CREATE TABLE tags (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL,

    CONSTRAINT uq_tags_slug UNIQUE (slug)
);

CREATE TABLE forum_post_tags (
    post_id UUID NOT NULL REFERENCES forum_posts (id) ON DELETE CASCADE,
    tag_id UUID NOT NULL REFERENCES tags (id) ON DELETE CASCADE,

    CONSTRAINT pk_forum_post_tags PRIMARY KEY (post_id, tag_id)
);

CREATE INDEX idx_forum_post_tags_tag_id ON forum_post_tags (tag_id);
