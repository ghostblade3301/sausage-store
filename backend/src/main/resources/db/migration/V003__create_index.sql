CREATE INDEX IF NOT EXISTS idx_ord_id ON orders(id);
CREATE INDEX IF NOT EXISTS idx_prd_id ON product(id);
CREATE INDEX IF NOT EXISTS idx_ord ON order_product(order_id);
CREATE INDEX IF NOT EXISTS idx_prd ON order_product(product_id);