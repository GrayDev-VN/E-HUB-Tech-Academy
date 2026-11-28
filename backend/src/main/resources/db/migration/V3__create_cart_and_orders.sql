CREATE TABLE carts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users (id),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_carts_user UNIQUE (user_id)
);

CREATE TABLE cart_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cart_id UUID NOT NULL REFERENCES carts (id) ON DELETE CASCADE,
    course_id UUID NOT NULL REFERENCES courses (id),
    added_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_cart_items_cart_course UNIQUE (cart_id, course_id)
);

CREATE INDEX idx_cart_items_course_id ON cart_items (course_id);

CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users (id),
    status VARCHAR(16) NOT NULL,
    total NUMERIC(19, 2) NOT NULL,
    currency VARCHAR(3) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    paid_at TIMESTAMPTZ,

    CONSTRAINT ck_orders_status CHECK (status IN ('PENDING', 'PAID', 'CANCELLED')),
    CONSTRAINT ck_orders_total CHECK (total > 0),
    CONSTRAINT ck_orders_currency CHECK (currency ~ '^[A-Z]{3}$')
);

CREATE INDEX idx_orders_user_created_at ON orders (user_id, created_at DESC);

CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES orders (id),
    course_id UUID NOT NULL REFERENCES courses (id),
    course_title_snapshot VARCHAR(255) NOT NULL,
    unit_price_snapshot NUMERIC(19, 2) NOT NULL,

    CONSTRAINT uq_order_items_order_course UNIQUE (order_id, course_id),
    CONSTRAINT uq_order_items_id_course UNIQUE (id, course_id),
    CONSTRAINT ck_order_items_unit_price CHECK (unit_price_snapshot > 0)
);

CREATE INDEX idx_order_items_course_id ON order_items (course_id);
