-- 添加已收货数量字段到采购订单表
ALTER TABLE procurement_system.purchase_order ADD COLUMN received_quantity INT DEFAULT 0 COMMENT '已收货数量';

-- 更新现有数据的已收货数量为0
UPDATE procurement_system.purchase_order SET received_quantity = 0 WHERE received_quantity IS NULL;