CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users (id),
    type VARCHAR(32) NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    reference_type VARCHAR(64),
    reference_id UUID,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMPTZ,

    CONSTRAINT ck_notifications_type CHECK (type IN ('ORDER_PAYMENT', 'SYSTEM'))
);

CREATE INDEX idx_notifications_user_created_at ON notifications (user_id, created_at DESC);

CREATE TABLE app_settings (
    key VARCHAR(128) PRIMARY KEY,
    value TEXT NOT NULL,
    value_type VARCHAR(32) NOT NULL,
    updated_by UUID REFERENCES users (id),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
