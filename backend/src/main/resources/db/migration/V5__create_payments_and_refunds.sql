CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID NOT NULL REFERENCES orders (id),
    provider VARCHAR(64) NOT NULL,
    provider_transaction_id VARCHAR(255),
    amount NUMERIC(19, 2) NOT NULL,
    currency VARCHAR(3) NOT NULL,
    status VARCHAR(16) NOT NULL,
    raw_reference TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    paid_at TIMESTAMPTZ,

    CONSTRAINT uq_payments_provider_transaction UNIQUE (provider, provider_transaction_id),
    CONSTRAINT ck_payments_amount CHECK (amount > 0),
    CONSTRAINT ck_payments_currency CHECK (currency ~ '^[A-Z]{3}$'),
    CONSTRAINT ck_payments_status CHECK (status IN ('PENDING', 'SUCCESS', 'FAILED'))
);

CREATE INDEX idx_payments_order_id ON payments (order_id);

CREATE TABLE refunds (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_item_id UUID NOT NULL REFERENCES order_items (id),
    requested_by UUID NOT NULL REFERENCES users (id),
    reviewed_by UUID REFERENCES users (id),
    amount NUMERIC(19, 2) NOT NULL,
    status VARCHAR(16) NOT NULL,
    reason TEXT NOT NULL,
    provider_completed_at TIMESTAMPTZ,

    CONSTRAINT ck_refunds_amount CHECK (amount > 0),
    CONSTRAINT ck_refunds_status CHECK (
        status IN ('REQUESTED', 'APPROVED', 'REJECTED', 'PROCESSING', 'SUCCESS', 'FAILED')
    )
);

CREATE INDEX idx_refunds_order_item_id ON refunds (order_item_id);
