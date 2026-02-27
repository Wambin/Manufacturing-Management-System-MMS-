/*
 Navicat Premium Data Transfer

 Source Server         : 4444
 Source Server Type    : MySQL
 Source Server Version : 80037 (8.0.37)
 Source Host           : localhost:3306
 Source Schema         : procurement_system

 Target Server Type    : MySQL
 Target Server Version : 80037 (8.0.37)
 File Encoding         : 65001

 Date: 22/02/2026 14:13:26
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for attachment
-- ----------------------------
DROP TABLE IF EXISTS `attachment`;
CREATE TABLE `attachment`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `business_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '业务类型',
  `business_id` bigint NOT NULL COMMENT '业务ID',
  `file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '原文件名',
  `file_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '存储路径',
  `file_size` bigint NULL DEFAULT NULL COMMENT '文件大小',
  `category` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '分类',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `deleted` tinyint NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '附件表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of attachment
-- ----------------------------

-- ----------------------------
-- Table structure for delivery_detail
-- ----------------------------
DROP TABLE IF EXISTS `delivery_detail`;
CREATE TABLE `delivery_detail`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `delivery_id` bigint NOT NULL COMMENT '发货记录ID',
  `material_id` bigint NOT NULL COMMENT '物料ID',
  `material_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物料编码',
  `material_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物料名称',
  `order_quantity` int NULL DEFAULT NULL COMMENT '订单数量',
  `shipped_quantity` int NULL DEFAULT NULL COMMENT '已发货数量',
  `current_quantity` int NOT NULL COMMENT '本次发货数量',
  `images` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '实物图JSON',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '发货明细表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of delivery_detail
-- ----------------------------

-- ----------------------------
-- Table structure for delivery_record
-- ----------------------------
DROP TABLE IF EXISTS `delivery_record`;
CREATE TABLE `delivery_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `delivery_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '发货单号',
  `order_id` bigint NOT NULL COMMENT '订单ID',
  `delivery_date` date NULL DEFAULT NULL COMMENT '发货日期',
  `tracking_no` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '快递单号',
  `vehicle_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '车/船编号',
  `delivery_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '发货地址',
  `contact_person` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系人',
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `receiver_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '收货人',
  `receiver_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '收货人电话',
  `receiver_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '收货地址',
  `delivery_note` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '发货单',
  `express_photo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '快递单照片',
  `packaging_photos` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '包装照片JSON',
  `product_photos` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '产品照片JSON',
  `certificate` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '合格证',
  `remark` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '备注',
  `status` tinyint NULL DEFAULT 0 COMMENT '状态: 0已发货 1已收货',
  `receive_time` datetime NULL DEFAULT NULL COMMENT '收货时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_delivery_no`(`delivery_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 33 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '发货记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of delivery_record
-- ----------------------------
INSERT INTO `delivery_record` VALUES (1, 'DN1771728990191', 4, '2026-02-22', '1', NULL, '1', '1', '1', '1', '1', '1', 'http://localhost:8080/uploads/2026/02/22/9d8a99ca-1bc6-4c7b-b145-ec97c1b3c570.png', 'http://localhost:8080/uploads/2026/02/22/aebaa564-a578-4344-9fd0-43d9d97b7990.png', NULL, NULL, NULL, '111', 1, '2026-02-22 11:26:47', '2026-02-22 10:56:30', '2026-02-22 10:56:30', 0);
INSERT INTO `delivery_record` VALUES (2, 'DN1771729809832', 7, '2026-02-22', '1', NULL, '1', '1', '1', '1', '1', '1', 'http://localhost:8080/uploads/2026/02/22/a53204dd-ca87-4ac9-a566-2cc069c173d3.png', 'http://localhost:8080/uploads/2026/02/22/f727d0ed-e535-481e-8566-dd459973a024.png', NULL, NULL, NULL, '1', 1, '2026-02-22 11:19:35', '2026-02-22 11:10:09', '2026-02-22 11:10:09', 0);
INSERT INTO `delivery_record` VALUES (3, 'DN1771730918055', 8, '2026-02-22', '1', NULL, '嗡嗡嗡', '我', '1', '1', '1', '1', 'http://localhost:8080/uploads/2026/02/22/87e7b78b-4ac9-4242-9bef-7a95e37d5f8d.png', 'http://localhost:8080/uploads/2026/02/22/309233f4-0222-4f95-b004-9fefe9a9ce71.png', NULL, NULL, NULL, '111', 1, '2026-02-22 12:03:24', '2026-02-22 11:28:38', '2026-02-22 11:28:38', 0);
INSERT INTO `delivery_record` VALUES (4, 'DN1771731353392', 8, '2026-02-22', '1', NULL, '1', '1', '1', '1', '1', '1', 'http://localhost:8080/uploads/2026/02/22/bbeb7f34-030b-4fea-8f47-6ab295ea1b69.png', 'http://localhost:8080/uploads/2026/02/22/7910f842-5d87-44d4-a775-83f44fac8dc0.png', NULL, NULL, NULL, '1', 1, '2026-02-22 12:03:22', '2026-02-22 11:35:53', '2026-02-22 11:35:53', 0);
INSERT INTO `delivery_record` VALUES (5, 'DN1771732071619', 7, '2026-02-22', '1', NULL, '1', '1', '1', '1', '1', '1', 'http://localhost:8080/uploads/2026/02/22/4e2420eb-a031-41e3-af5b-bbc530058183.png', 'http://localhost:8080/uploads/2026/02/22/a7d3ae11-b8c6-4015-9bfa-6feab344feb4.png', NULL, NULL, NULL, '', 1, '2026-02-22 12:03:21', '2026-02-22 11:47:51', '2026-02-22 11:47:51', 0);
INSERT INTO `delivery_record` VALUES (6, 'DN1771732156401', 7, '2026-02-22', '1', NULL, '1', '1', '1', '1', '1', '1', 'http://localhost:8080/uploads/2026/02/22/54255459-b2ba-47a6-99c7-99fd885b8bb1.png', 'http://localhost:8080/uploads/2026/02/22/d50858b6-727d-42a9-822c-2091db768518.png', NULL, NULL, NULL, '1', 1, '2026-02-22 12:03:19', '2026-02-22 11:49:16', '2026-02-22 11:49:16', 0);
INSERT INTO `delivery_record` VALUES (7, 'DN1771732630439', 8, '2026-02-22', '1', NULL, '1', '1', '1', '1', '1', '1', 'http://localhost:8080/uploads/2026/02/22/be403370-2315-4e91-9783-90259621d9a4.png', 'http://localhost:8080/uploads/2026/02/22/598dc3de-2c65-4772-933c-b0569e7df7e6.png', NULL, NULL, NULL, '1', 1, '2026-02-22 12:03:18', '2026-02-22 11:57:10', '2026-02-22 11:57:10', 0);
INSERT INTO `delivery_record` VALUES (8, 'DN1771733058954', 9, '2026-02-22', '1', NULL, '1', '1', '1', '1', '1', '1', 'http://localhost:8080/uploads/2026/02/22/f07f86b9-77ee-45a6-b698-ee0f13f5e9fe.png', 'http://localhost:8080/uploads/2026/02/22/392c89bf-5916-47a8-b160-0af03c5c2c5c.png', NULL, NULL, NULL, '1', 1, '2026-02-22 12:04:37', '2026-02-22 12:04:18', '2026-02-22 12:04:18', 0);
INSERT INTO `delivery_record` VALUES (9, 'DN1771733230590', 9, '2026-02-22', '1', NULL, '1', '11', '1', '11', '11', '1', 'http://localhost:8080/uploads/2026/02/22/9b9689e3-d5bb-4965-b813-6e81c6eeba00.png', 'http://localhost:8080/uploads/2026/02/22/e19a07bd-89b2-40f4-8616-5a24ead07e51.png', NULL, NULL, NULL, '1', 1, '2026-02-22 12:07:55', '2026-02-22 12:07:10', '2026-02-22 12:07:10', 0);
INSERT INTO `delivery_record` VALUES (10, 'DN1771733384025', 9, '2026-02-22', '1', NULL, '1', '1', '1', '1', '1', '1', 'http://localhost:8080/uploads/2026/02/22/8078cb77-0a2d-4730-b9b0-07970db4025a.png', 'http://localhost:8080/uploads/2026/02/22/bf938559-d6c5-4788-b5e2-83e940700e17.png', NULL, NULL, NULL, '1', 1, '2026-02-22 12:09:58', '2026-02-22 12:09:44', '2026-02-22 12:09:44', 0);
INSERT INTO `delivery_record` VALUES (11, 'DN1771733522656', 9, '2026-02-22', '1', NULL, '1', '1', '1', '1', '1', '1', 'http://localhost:8080/uploads/2026/02/22/7124b789-0dda-4161-b478-fd84723d3aa3.png', 'http://localhost:8080/uploads/2026/02/22/48db4b55-c200-402a-818a-d4be01ea1e5d.png', NULL, NULL, NULL, '', 1, '2026-02-22 12:12:13', '2026-02-22 12:12:02', '2026-02-22 12:12:02', 0);
INSERT INTO `delivery_record` VALUES (12, 'DN1771734033450', 9, '2026-02-22', '1', NULL, '1', '1', '1', '1', '1', '1', 'http://localhost:8080/uploads/2026/02/22/bd7dda8f-e847-4dad-89ef-140482b6542c.png', 'http://localhost:8080/uploads/2026/02/22/2e5742ba-d569-4f03-86f8-e4ac3097dcd0.png', NULL, NULL, NULL, '1', 1, '2026-02-22 12:29:35', '2026-02-22 12:20:33', '2026-02-22 12:20:33', 0);
INSERT INTO `delivery_record` VALUES (13, 'DN1771734336632', 10, '2026-02-22', '1', NULL, '1', '1', '1', '1', '1', '1', 'http://localhost:8080/uploads/2026/02/22/e28d4aa9-0573-49d1-9dc1-50075027f022.png', 'http://localhost:8080/uploads/2026/02/22/1ab77e65-0d66-4abf-9b32-3ce0e094b6f4.png', NULL, NULL, NULL, '1', 1, '2026-02-22 12:29:33', '2026-02-22 12:25:36', '2026-02-22 12:25:36', 0);
INSERT INTO `delivery_record` VALUES (14, 'DN1771734540702', 11, '2026-02-22', '1', NULL, '1', '1', '1', '1', '1', '1', 'http://localhost:8080/uploads/2026/02/22/a861990f-25a2-4fee-b524-eeaf04d39e7c.png', 'http://localhost:8080/uploads/2026/02/22/5da0e2bd-2046-4245-b8d4-0e5f196c3b1c.png', NULL, NULL, NULL, '1', 1, '2026-02-22 12:29:31', '2026-02-22 12:29:00', '2026-02-22 12:29:00', 0);
INSERT INTO `delivery_record` VALUES (15, 'DN1771735469386', 17, '2026-02-22', '1', NULL, '1', '1', '1', '1', '1', '1', 'http://localhost:8080/uploads/2026/02/22/fc79d201-c76d-4b0d-9f1d-6e755f1b21e7.png', 'http://localhost:8080/uploads/2026/02/22/7296647c-184a-439e-b9c5-9aa674cc92c6.png', NULL, NULL, NULL, '1', 1, '2026-02-22 12:46:07', '2026-02-22 12:44:29', '2026-02-22 12:44:29', 0);
INSERT INTO `delivery_record` VALUES (16, 'DN1771735533214', 13, '2026-02-22', '1', NULL, '11', '1', '1', '11', '11', '11', 'http://localhost:8080/uploads/2026/02/22/1603a945-7789-4799-9370-c11f675f8358.png', 'http://localhost:8080/uploads/2026/02/22/42c7072d-af2e-44d7-a82f-1126a13e3ff8.png', NULL, NULL, NULL, '1', 1, '2026-02-22 12:46:05', '2026-02-22 12:45:33', '2026-02-22 12:45:33', 0);
INSERT INTO `delivery_record` VALUES (17, 'DN1771735727945', 18, '2026-02-22', '1', NULL, '1', '1', '1', '1', '1', '1', 'http://localhost:8080/uploads/2026/02/22/7914b224-f493-47f9-b209-999c02b1e231.png', 'http://localhost:8080/uploads/2026/02/22/99b67194-d3c4-45d1-978e-f08243c678c5.png', NULL, NULL, NULL, '1', 1, '2026-02-22 12:55:18', '2026-02-22 12:48:47', '2026-02-22 12:48:47', 0);
INSERT INTO `delivery_record` VALUES (18, 'DN1771735962612', 19, '2026-02-22', '1', NULL, '1', '1', '1', '1', '1', '1', 'http://localhost:8080/uploads/2026/02/22/c258422f-331b-4600-ab76-ee9840a331fa.png', 'http://localhost:8080/uploads/2026/02/22/554e5e7a-3ac9-4994-8434-e8555764c477.png', NULL, NULL, NULL, '1', 1, '2026-02-22 12:55:20', '2026-02-22 12:52:42', '2026-02-22 12:52:42', 0);
INSERT INTO `delivery_record` VALUES (19, 'DN1771736071681', 14, '2026-02-22', '1', NULL, '1', '1', '1', '1', '1', '1', 'http://localhost:8080/uploads/2026/02/22/7ea3237e-2977-4283-a588-c7e00cb017c0.png', 'http://localhost:8080/uploads/2026/02/22/5cc48fdf-a0ba-45bc-997d-35e1485def54.png', NULL, NULL, NULL, '1', 1, '2026-02-22 12:55:21', '2026-02-22 12:54:31', '2026-02-22 12:54:31', 0);
INSERT INTO `delivery_record` VALUES (20, 'DN1771736527294', 20, '2026-02-22', '1', NULL, '1', '1', '1', '1', '1', '1', 'http://localhost:8080/uploads/2026/02/22/e821883c-c423-44b5-89e9-fde431fe87a2.png', 'http://localhost:8080/uploads/2026/02/22/7095c598-15c9-4c32-9754-3b197fcb29e7.png', NULL, NULL, NULL, '1', 1, '2026-02-22 13:02:25', '2026-02-22 13:02:07', '2026-02-22 13:02:07', 0);
INSERT INTO `delivery_record` VALUES (21, 'DN1771736644873', 21, '2026-02-22', '1', NULL, '1', '1', '1', '1', '1', '1', 'http://localhost:8080/uploads/2026/02/22/7b9e44f6-a7f4-4654-9c23-1019fa20a05a.png', 'http://localhost:8080/uploads/2026/02/22/75670e6d-d872-40a8-b459-8ccf684d5362.png', NULL, NULL, NULL, '1', 1, '2026-02-22 13:07:34', '2026-02-22 13:04:04', '2026-02-22 13:04:04', 0);
INSERT INTO `delivery_record` VALUES (22, 'DN1771736805036', 23, '2026-02-22', '1', NULL, '1', '1', '1', '1', '1', '1', 'http://localhost:8080/uploads/2026/02/22/e6188b26-1dee-4308-b5ba-db06137eb888.png', 'http://localhost:8080/uploads/2026/02/22/9f9d03e8-f7f5-4033-bfdd-1a7918866c5c.png', NULL, NULL, NULL, '1', 1, '2026-02-22 13:07:32', '2026-02-22 13:06:45', '2026-02-22 13:06:45', 0);
INSERT INTO `delivery_record` VALUES (23, 'DN1771736831919', 22, '2026-02-22', '1', NULL, '1', '1', '1', '1', '', '1', 'http://localhost:8080/uploads/2026/02/22/7f1b1374-6023-4c61-afd7-b9357e3504e7.png', 'http://localhost:8080/uploads/2026/02/22/f4ed310f-1cf7-45dc-b6b5-95315d663d24.png', NULL, NULL, NULL, '1', 1, '2026-02-22 13:07:31', '2026-02-22 13:07:11', '2026-02-22 13:07:11', 0);
INSERT INTO `delivery_record` VALUES (24, 'DN1771737486971', 25, '2026-02-22', '1', NULL, '1', '1', '1', '1', '1', '1', 'http://localhost:8080/uploads/2026/02/22/c8e0225b-9fa4-4247-851c-20d4e3e4c6fa.png', 'http://localhost:8080/uploads/2026/02/22/0b7108d3-0526-4395-b0a2-a640f6bbf83e.png', NULL, NULL, NULL, '', 1, '2026-02-22 13:18:46', '2026-02-22 13:18:06', '2026-02-22 13:18:06', 0);
INSERT INTO `delivery_record` VALUES (25, 'DN1771737505280', 24, '2026-02-22', '1', NULL, '1', '1', '1', '1', '1', '1', 'http://localhost:8080/uploads/2026/02/22/73137538-8339-4e63-a574-f7e8f9e33705.png', 'http://localhost:8080/uploads/2026/02/22/6d262121-c5a0-4eef-b690-aee61a88aa8b.png', NULL, NULL, NULL, '1', 1, '2026-02-22 13:18:49', '2026-02-22 13:18:25', '2026-02-22 13:18:25', 0);
INSERT INTO `delivery_record` VALUES (26, 'DN1771737656987', 27, '2026-02-22', '1', NULL, '1', '1', '1', '1', '1', '1', 'http://localhost:8080/uploads/2026/02/22/d06c1407-139c-4c1c-96ee-766147908846.png', 'http://localhost:8080/uploads/2026/02/22/15cbcbbe-f0c6-4e80-8227-b54ecb378074.png', NULL, NULL, NULL, '1', 1, '2026-02-22 13:22:36', '2026-02-22 13:20:56', '2026-02-22 13:20:56', 0);
INSERT INTO `delivery_record` VALUES (27, 'DN1771737735348', 26, '2026-02-22', '1', NULL, '1', '1', '1', '1', '1', '1', 'http://localhost:8080/uploads/2026/02/22/c53cff42-9e87-4365-825c-e814d20b5c5f.png', 'http://localhost:8080/uploads/2026/02/22/f2646937-ad15-449e-a322-01ce426753f3.png', NULL, NULL, NULL, '', 1, '2026-02-22 13:22:35', '2026-02-22 13:22:15', '2026-02-22 13:22:15', 0);
INSERT INTO `delivery_record` VALUES (28, 'DN1771737955964', 29, '2026-02-22', '1', NULL, '1', '1', '1', '1', '1', '1', 'http://localhost:8080/uploads/2026/02/22/d5dc1dfb-fdc6-4f1f-bf4a-2080c223fede.png', 'http://localhost:8080/uploads/2026/02/22/a228c59d-883b-4169-bdd1-497fd9045219.png', NULL, NULL, NULL, '1', 1, '2026-02-22 13:26:39', '2026-02-22 13:25:55', '2026-02-22 13:25:55', 0);
INSERT INTO `delivery_record` VALUES (29, 'DN1771737968741', 29, '2026-02-22', '1', NULL, '1', '1', '1', '1', '1', '1', 'http://localhost:8080/uploads/2026/02/22/9d538941-5554-4a84-8282-186b850af8d6.png', 'http://localhost:8080/uploads/2026/02/22/a307f573-993f-4830-b1d8-5c9f78141d90.png', NULL, NULL, NULL, '', 1, '2026-02-22 13:26:38', '2026-02-22 13:26:08', '2026-02-22 13:26:08', 0);
INSERT INTO `delivery_record` VALUES (30, 'DN1771737984360', 30, '2026-02-22', '1', NULL, '1', '1', '1', '1', '1', '1', 'http://localhost:8080/uploads/2026/02/22/d790d511-ac6a-4dbe-85d0-9cfc4ac4cc3f.png', 'http://localhost:8080/uploads/2026/02/22/47fcc55c-48fa-40f8-a43e-69b2934b23ca.png', NULL, NULL, NULL, '', 1, '2026-02-22 13:26:36', '2026-02-22 13:26:24', '2026-02-22 13:26:24', 0);
INSERT INTO `delivery_record` VALUES (31, 'DN1771738165621', 28, '2026-02-22', '1', NULL, '1', '1', '1', '1', '1', '1', 'http://localhost:8080/uploads/2026/02/22/ed9b7f22-54e9-4dee-905c-264b2ebc6491.png', 'http://localhost:8080/uploads/2026/02/22/5733f42d-8545-4d19-8f4c-178755031884.png', NULL, NULL, NULL, '1', 0, NULL, '2026-02-22 13:29:25', '2026-02-22 13:29:25', 0);
INSERT INTO `delivery_record` VALUES (32, 'DN1771739353343', 31, '2026-02-22', '112121', NULL, '武汉市洪山区', '蕉太狼', '110110', '灰太狼', '1111', '武汉市汉口', 'http://localhost:8080/uploads/2026/02/22/55ebbb6c-8208-4c56-a9c7-fc9e61f9a42a.png', 'http://localhost:8080/uploads/2026/02/22/c0b59012-c59d-4d7b-b090-a55ea73055cf.png', NULL, NULL, NULL, '1', 1, '2026-02-22 13:49:37', '2026-02-22 13:49:13', '2026-02-22 13:49:13', 0);

-- ----------------------------
-- Table structure for material
-- ----------------------------
DROP TABLE IF EXISTS `material`;
CREATE TABLE `material`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `material_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '物料编码',
  `material_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '物料名称',
  `material_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '物料类型',
  `specification` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '规格型号',
  `material` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '材质',
  `unit` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '单位',
  `weight` decimal(10, 2) NULL DEFAULT NULL COMMENT '重量',
  `size` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '尺寸',
  `technical_params` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '技术参数',
  `main_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '主图',
  `auxiliary_images` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '辅助图JSON',
  `drawings` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '图纸文件JSON',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态: 0禁用 1启用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_material_code`(`material_code` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '物料表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of material
-- ----------------------------

-- ----------------------------
-- Table structure for project
-- ----------------------------
DROP TABLE IF EXISTS `project`;
CREATE TABLE `project`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `project_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '项目编号',
  `project_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '项目名称',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'planning' COMMENT '状态: planning,ongoing,completed',
  `equipment_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '设备编号',
  `project_manager` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '项目经理',
  `start_date` date NULL DEFAULT NULL COMMENT '开始日期',
  `end_date` date NULL DEFAULT NULL COMMENT '结束日期',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '项目描述',
  `equipment_images` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '设备图片JSON',
  `drawings` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '图纸文件JSON',
  `site_photos` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '现场照片JSON',
  `create_user_id` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_project_no`(`project_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '项目表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of project
-- ----------------------------
INSERT INTO `project` VALUES (1, '202601', '狼堡翻新计划', 'planning', '20260101', '白太郎', '2026-02-22', '2026-02-28', '狼狈屋顶翻新', '[\"http://localhost:8080/uploads/2026/02/22/063ef119-e43b-4b02-8af3-4b3cf9b85084.png\"]', NULL, '[\"http://localhost:8080/uploads/2026/02/22/2d6277d9-4e4a-48d0-bc61-bea94766c9ae.png\"]', NULL, '2026-02-22 10:39:43', '2026-02-22 10:39:43', 0);

-- ----------------------------
-- Table structure for purchase_order
-- ----------------------------
DROP TABLE IF EXISTS `purchase_order`;
CREATE TABLE `purchase_order`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '订单号',
  `plan_id` bigint NULL DEFAULT NULL COMMENT '采购方案ID',
  `project_id` bigint NOT NULL COMMENT '项目ID',
  `supplier_id` bigint NOT NULL COMMENT '供应商ID',
  `contract_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '合同号',
  `purchase_date` date NULL DEFAULT NULL COMMENT '采购日期',
  `delivery_date` date NULL DEFAULT NULL COMMENT '交货日期',
  `manager_auditor` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '经理审核人',
  `materials` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '物料清单JSON',
  `attachments` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '附件JSON',
  `total_quantity` int NULL DEFAULT 0 COMMENT '订单总数',
  `shipped_quantity` int NULL DEFAULT 0 COMMENT '已发货数量',
  `total_amount` decimal(12, 2) NULL DEFAULT NULL COMMENT '总金额',
  `status` tinyint NULL DEFAULT 0 COMMENT '状态: 0草稿 1待履约 2部分发货 3已发货 4已收货',
  `create_user_id` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `request_id` bigint NULL DEFAULT NULL COMMENT '采购申请ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NULL DEFAULT 0,
  `received_quantity` int NULL DEFAULT 0 COMMENT '已收货数量',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_order_no`(`order_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 32 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '采购订单表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of purchase_order
-- ----------------------------
INSERT INTO `purchase_order` VALUES (1, 'PO1771728235073', NULL, 1, 1, '202601', '2026-02-11', '2026-02-04', NULL, '[{\"materialCode\":\"01\",\"materialName\":\"水泥\",\"specification\":\"2026\",\"material\":\"混凝土\",\"quantity\":1,\"unit\":\"袋\",\"image\":\"http://localhost:8080/uploads/2026/02/22/da561ef3-5fca-4afe-a3d1-21b27d282525.png\",\"remark\":\"\"}]', NULL, 0, 0, NULL, 1, NULL, 1, '2026-02-22 10:43:55', '2026-02-22 10:43:55', 0, 0);
INSERT INTO `purchase_order` VALUES (2, 'PO1771728558119', NULL, 1, 1, 'CONTRACT20260222389544', '2026-02-11', '2026-02-12', NULL, '[{\"materialCode\":\"01\",\"materialName\":\"水泥\",\"specification\":\"2026\",\"material\":\"混凝土\",\"quantity\":1,\"unit\":\"袋\",\"image\":\"http://localhost:8080/uploads/2026/02/22/da561ef3-5fca-4afe-a3d1-21b27d282525.png\",\"remark\":\"\"}]', NULL, 0, 0, NULL, 0, NULL, 1, '2026-02-22 10:49:18', '2026-02-22 10:49:18', 0, 0);
INSERT INTO `purchase_order` VALUES (3, 'PO1771728597710', NULL, 1, 2, 'CONTRACT20260222811952', '2026-02-11', '2026-02-17', NULL, '[{\"materialCode\":\"01\",\"materialName\":\"水泥\",\"specification\":\"2026\",\"material\":\"混凝土\",\"quantity\":1,\"unit\":\"袋\",\"image\":\"http://localhost:8080/uploads/2026/02/22/da561ef3-5fca-4afe-a3d1-21b27d282525.png\",\"remark\":\"\"}]', NULL, 0, 0, NULL, 1, NULL, 1, '2026-02-22 10:49:57', '2026-02-22 10:49:57', 0, 0);
INSERT INTO `purchase_order` VALUES (4, 'PO1771728634157', NULL, 1, 2, 'CONTRACT20260222464980', '2026-02-03', '2026-02-10', NULL, '[{\"materialCode\":\"01\",\"materialName\":\"水泥\",\"specification\":\"2026\",\"material\":\"混凝土\",\"quantity\":1,\"unit\":\"袋\",\"image\":\"http://localhost:8080/uploads/2026/02/22/da561ef3-5fca-4afe-a3d1-21b27d282525.png\",\"remark\":\"\"}]', NULL, 0, 0, NULL, 1, NULL, 1, '2026-02-22 10:50:34', '2026-02-22 10:50:34', 0, 0);
INSERT INTO `purchase_order` VALUES (5, 'PO1771728735187', NULL, 1, 2, 'CONTRACT20260222541902', '2026-02-17', '2026-02-19', NULL, '[{\"materialCode\":\"1\",\"materialName\":\"1\",\"specification\":\"1\",\"material\":\"1\",\"quantity\":1,\"unit\":\"\",\"image\":\"\",\"remark\":\"1\"}]', NULL, 0, 0, NULL, 0, NULL, 2, '2026-02-22 10:52:15', '2026-02-22 10:52:15', 0, 0);
INSERT INTO `purchase_order` VALUES (6, 'PO1771728917297', NULL, 1, 1, 'CONTRACT20260222217691', '2026-02-17', '2026-02-11', NULL, '[{\"materialCode\":\"01\",\"materialName\":\"水泥\",\"specification\":\"2026\",\"material\":\"混凝土\",\"quantity\":1,\"unit\":\"袋\",\"image\":\"http://localhost:8080/uploads/2026/02/22/da561ef3-5fca-4afe-a3d1-21b27d282525.png\",\"remark\":\"\"}]', NULL, 0, 0, NULL, 0, NULL, 1, '2026-02-22 10:55:17', '2026-02-22 10:55:17', 0, 0);
INSERT INTO `purchase_order` VALUES (7, 'PO1771729782538', NULL, 1, 3, 'CONTRACT20260222516616', '2026-02-25', '2026-02-04', NULL, '[{\"materialCode\":\"1\",\"materialName\":\"1\",\"specification\":\"1\",\"material\":\"1\",\"quantity\":1,\"unit\":\"个\",\"image\":\"\",\"remark\":\"1\"}]', NULL, 0, 1, NULL, 4, NULL, 3, '2026-02-22 11:09:42', '2026-02-22 12:00:24', 0, 0);
INSERT INTO `purchase_order` VALUES (8, 'PO1771730826856', NULL, 1, 3, 'CONTRACT20260222765012', '2026-02-27', '2026-02-26', NULL, '[{\"materialCode\":\"1\",\"materialName\":\"1\",\"specification\":\"1\",\"material\":\"1\",\"quantity\":1,\"unit\":\"个\",\"image\":\"\",\"remark\":\"1\"}]', NULL, 0, 1, NULL, 4, NULL, 3, '2026-02-22 11:27:06', '2026-02-22 12:00:39', 0, 0);
INSERT INTO `purchase_order` VALUES (9, 'PO1771732993009', NULL, 1, 3, 'CONTRACT20260222474076', '2026-02-24', '2026-02-02', NULL, '[{\"materialCode\":\"1\",\"materialName\":\"1\",\"specification\":\"1\",\"material\":\"1\",\"quantity\":1,\"unit\":\"个\",\"image\":\"\",\"remark\":\"1\"}]', NULL, 1, 5, NULL, 4, NULL, 3, '2026-02-22 12:03:13', '2026-02-22 12:20:33', 0, 1);
INSERT INTO `purchase_order` VALUES (10, 'PO1771734304719', NULL, 1, 3, 'CONTRACT20260222766113', '2026-02-20', '2026-02-18', NULL, '[{\"materialCode\":\"1\",\"materialName\":\"1\",\"specification\":\"1\",\"material\":\"1\",\"quantity\":1,\"unit\":\"个\",\"image\":\"\",\"remark\":\"1\"}]', NULL, 1, 1, NULL, 4, NULL, 3, '2026-02-22 12:25:04', '2026-02-22 12:25:36', 0, 1);
INSERT INTO `purchase_order` VALUES (11, 'PO1771734453720', NULL, 1, 3, 'CONTRACT20260222922853', NULL, NULL, NULL, '[{\"materialCode\":\"1\",\"materialName\":\"1\",\"specification\":\"1\",\"material\":\"1\",\"quantity\":14,\"unit\":\"个\",\"image\":\"\",\"remark\":\"1\",\"price\":111}]', NULL, 14, 1, NULL, 4, NULL, 3, '2026-02-22 12:27:33', '2026-02-22 12:29:07', 0, 1);
INSERT INTO `purchase_order` VALUES (12, 'PO1771734775002', NULL, 1, 3, 'CONTRACT20260222289244', '2026-02-25', '2026-02-18', NULL, '[{\"materialCode\":\"1\",\"materialName\":\"1\",\"specification\":\"1\",\"material\":\"1\",\"quantity\":1,\"unit\":\"个\",\"image\":\"\",\"remark\":\"1\",\"price\":1111}]', NULL, 1, 0, NULL, 3, NULL, 3, '2026-02-22 12:32:55', '2026-02-22 13:04:31', 0, 0);
INSERT INTO `purchase_order` VALUES (13, 'PO1771735113214', NULL, 1, 3, 'CONTRACT20260222340192', '2026-02-11', '2026-02-20', NULL, '[{\"materialCode\":\"1\",\"materialName\":\"1\",\"specification\":\"1\",\"material\":\"1\",\"quantity\":1,\"unit\":\"个\",\"image\":\"\",\"remark\":\"1\"}]', NULL, 1, 1, NULL, 4, NULL, 3, '2026-02-22 12:38:33', '2026-02-22 12:45:33', 0, 1);
INSERT INTO `purchase_order` VALUES (14, 'PO1771735152704', NULL, 1, 3, 'CONTRACT20260222812943', '2026-02-24', '2026-02-19', NULL, '[{\"materialCode\":\"01\",\"materialName\":\"水泥\",\"specification\":\"2026\",\"material\":\"混凝土\",\"quantity\":1,\"unit\":\"袋\",\"image\":\"http://localhost:8080/uploads/2026/02/22/da561ef3-5fca-4afe-a3d1-21b27d282525.png\",\"remark\":\"\"}]', NULL, 1, 1, NULL, 4, NULL, 1, '2026-02-22 12:39:12', '2026-02-22 12:54:44', 0, 1);
INSERT INTO `purchase_order` VALUES (15, 'PO1771735309302', NULL, 1, 3, 'CONTRACT20260222252542', '2026-02-24', '2026-02-26', NULL, '[{\"materialCode\":\"1\",\"materialName\":\"1\",\"specification\":\"1\",\"material\":\"1\",\"quantity\":1,\"unit\":\"个\",\"image\":\"\",\"remark\":\"1\"}]', NULL, 1, 0, NULL, 3, NULL, 3, '2026-02-22 12:41:49', '2026-02-22 12:45:08', 0, 0);
INSERT INTO `purchase_order` VALUES (16, 'PO1771735355643', NULL, 1, 3, 'CONTRACT20260222708450', '2026-02-25', '2026-02-27', NULL, '[{\"materialCode\":\"1\",\"materialName\":\"1\",\"specification\":\"1\",\"material\":\"1\",\"quantity\":1,\"unit\":\"个\",\"image\":\"\",\"remark\":\"1\"}]', NULL, 1, 0, NULL, 0, NULL, 3, '2026-02-22 12:42:35', '2026-02-22 12:42:35', 0, 0);
INSERT INTO `purchase_order` VALUES (17, 'PO1771735384933', NULL, 1, 3, 'CONTRACT20260222185118', '2026-02-24', '2026-02-21', NULL, '[{\"materialCode\":\"1\",\"materialName\":\"1\",\"specification\":\"1\",\"material\":\"1\",\"quantity\":1,\"unit\":\"个\",\"image\":\"\",\"remark\":\"1\"}]', NULL, 1, 1, NULL, 4, NULL, 3, '2026-02-22 12:43:04', '2026-02-22 12:44:29', 0, 1);
INSERT INTO `purchase_order` VALUES (18, 'PO1771735691925', NULL, 1, 3, 'CONTRACT20260222464648', '2026-02-17', '2026-02-24', NULL, '[{\"materialCode\":\"1\",\"materialName\":\"1\",\"specification\":\"1\",\"material\":\"1\",\"quantity\":1,\"unit\":\"1\",\"image\":\"\",\"remark\":\"1\"}]', NULL, 1, 1, NULL, 4, NULL, 4, '2026-02-22 12:48:11', '2026-02-22 12:48:47', 0, 1);
INSERT INTO `purchase_order` VALUES (19, 'PO1771735862955', NULL, 1, 3, 'CONTRACT20260222724104', '2026-02-24', '2026-02-26', NULL, '[{\"materialCode\":\"1222\",\"materialName\":\"1\",\"specification\":\"1\",\"material\":\"1\",\"quantity\":1,\"unit\":\"1\",\"image\":\"\",\"remark\":\"1\"}]', NULL, 1, 1, NULL, 4, NULL, 4, '2026-02-22 12:51:02', '2026-02-22 12:52:42', 0, 1);
INSERT INTO `purchase_order` VALUES (20, 'PO1771736501260', NULL, 1, 3, 'CONTRACT20260222708995', '2026-02-25', '2026-02-23', NULL, '[{\"materialCode\":\"122\",\"materialName\":\"133\",\"specification\":\"133\",\"material\":\"1\",\"quantity\":3,\"unit\":\"1\",\"image\":\"\",\"remark\":\"1\",\"price\":33}]', NULL, 3, 1, NULL, 4, NULL, 4, '2026-02-22 13:01:41', '2026-02-22 13:02:07', 0, 1);
INSERT INTO `purchase_order` VALUES (21, 'PO1771736614085', NULL, 1, 3, 'CONTRACT20260222945577', '2026-02-25', '2026-02-10', NULL, '[{\"materialCode\":\"1222\",\"materialName\":\"1\",\"specification\":\"1\",\"material\":\"1\",\"quantity\":1,\"unit\":\"1\",\"image\":\"\",\"remark\":\"1\",\"price\":1111}]', NULL, 1, 1, NULL, 4, NULL, 4, '2026-02-22 13:03:34', '2026-02-22 13:04:39', 0, 1);
INSERT INTO `purchase_order` VALUES (22, 'PO1771736744163', NULL, 1, 3, 'CONTRACT20260222267324', '2026-02-03', '2026-02-18', NULL, '[{\"materialCode\":\"1\",\"materialName\":\"1\",\"specification\":\"1\",\"material\":\"1\",\"quantity\":1,\"unit\":\"1\",\"image\":\"\",\"remark\":\"1\"}]', NULL, 1, 1, NULL, 4, NULL, 4, '2026-02-22 13:05:44', '2026-02-22 13:07:11', 0, 1);
INSERT INTO `purchase_order` VALUES (23, 'PO1771736753691', NULL, 1, 3, 'CONTRACT20260222618391', '2026-02-04', '2026-02-16', NULL, '[{\"materialCode\":\"1\",\"materialName\":\"1\",\"specification\":\"1\",\"material\":\"1\",\"quantity\":1,\"unit\":\"1\",\"image\":\"\",\"remark\":\"1\"}]', NULL, 1, 1, NULL, 4, NULL, 4, '2026-02-22 13:05:53', '2026-02-22 13:06:45', 0, 1);
INSERT INTO `purchase_order` VALUES (24, 'PO1771737443407', NULL, 1, 3, 'CONTRACT20260222825030', '2026-02-24', '2026-02-18', NULL, '[{\"materialCode\":\"1\",\"materialName\":\"1\",\"specification\":\"1\",\"material\":\"1\",\"quantity\":1,\"unit\":\"1\",\"image\":\"\",\"remark\":\"1\"}]', NULL, 1, 1, NULL, 4, NULL, 4, '2026-02-22 13:17:23', '2026-02-22 13:18:25', 0, 1);
INSERT INTO `purchase_order` VALUES (25, 'PO1771737458807', NULL, 1, 3, 'CONTRACT20260222514553', '2026-02-25', '2026-02-18', NULL, '[{\"materialCode\":\"1\",\"materialName\":\"1\",\"specification\":\"1\",\"material\":\"1\",\"quantity\":1,\"unit\":\"1\",\"image\":\"\",\"remark\":\"1\"}]', NULL, 1, 1, NULL, 4, NULL, 4, '2026-02-22 13:17:38', '2026-02-22 13:18:06', 0, 1);
INSERT INTO `purchase_order` VALUES (26, 'PO1771737613567', NULL, 1, 3, 'CONTRACT20260222102503', '2026-02-23', '2026-02-26', NULL, '[{\"materialCode\":\"1\",\"materialName\":\"1\",\"specification\":\"1\",\"material\":\"1\",\"quantity\":1,\"unit\":\"1\",\"image\":\"\",\"remark\":\"1\"}]', NULL, 1, 1, NULL, 4, NULL, 4, '2026-02-22 13:20:13', '2026-02-22 13:22:15', 0, 1);
INSERT INTO `purchase_order` VALUES (27, 'PO1771737626983', NULL, 1, 3, 'CONTRACT20260222681744', '2026-02-16', '2026-02-27', NULL, '[{\"materialCode\":\"1\",\"materialName\":\"1\",\"specification\":\"1\",\"material\":\"1\",\"quantity\":1,\"unit\":\"\",\"image\":\"\",\"remark\":\"1\"}]', NULL, 1, 1, NULL, 4, NULL, 2, '2026-02-22 13:20:26', '2026-02-22 13:20:59', 0, 1);
INSERT INTO `purchase_order` VALUES (28, 'PO1771737905763', NULL, 1, 3, 'CONTRACT20260222611128', '2026-02-25', '2026-02-26', NULL, '[{\"materialCode\":\"1\",\"materialName\":\"1\",\"specification\":\"1\",\"material\":\"1\",\"quantity\":1,\"unit\":\"1\",\"image\":\"\",\"remark\":\"1\"}]', NULL, 1, 1, NULL, 3, NULL, 4, '2026-02-22 13:25:05', '2026-02-22 13:29:29', 0, 0);
INSERT INTO `purchase_order` VALUES (29, 'PO1771737916099', NULL, 1, 3, 'CONTRACT20260222147570', '2026-02-26', NULL, NULL, '[{\"materialCode\":\"1\",\"materialName\":\"1\",\"specification\":\"1\",\"material\":\"1\",\"quantity\":1,\"unit\":\"1\",\"image\":\"\",\"remark\":\"1\"}]', NULL, 1, 2, NULL, 3, NULL, 4, '2026-02-22 13:25:16', '2026-02-22 13:28:57', 0, 2);
INSERT INTO `purchase_order` VALUES (30, 'PO1771737925953', NULL, 1, 3, 'CONTRACT20260222639229', '2026-02-20', '2026-02-19', NULL, '[{\"materialCode\":\"1\",\"materialName\":\"1\",\"specification\":\"1\",\"material\":\"1\",\"quantity\":1,\"unit\":\"个\",\"image\":\"\",\"remark\":\"1\"}]', NULL, 1, 1, NULL, 3, NULL, 3, '2026-02-22 13:25:25', '2026-02-22 13:28:44', 0, 1);
INSERT INTO `purchase_order` VALUES (31, 'PO1771739245257', NULL, 1, 3, 'CONTRACT20260222888677', '2026-02-22', '2026-02-28', NULL, '[{\"materialCode\":\"0101\",\"materialName\":\"钢筋\",\"specification\":\"01\",\"material\":\"钢筋\",\"quantity\":1,\"unit\":\"根\",\"image\":\"http://localhost:8080/uploads/2026/02/22/ada998cf-1904-4bca-802e-7c89724f0fca.png\",\"remark\":\"111\",\"price\":100}]', NULL, 1, 1, NULL, 3, NULL, 5, '2026-02-22 13:47:25', '2026-02-22 13:50:01', 0, 1);

-- ----------------------------
-- Table structure for purchase_plan
-- ----------------------------
DROP TABLE IF EXISTS `purchase_plan`;
CREATE TABLE `purchase_plan`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `plan_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '方案编号',
  `request_id` bigint NOT NULL COMMENT '采购申请ID',
  `supplier_id` bigint NULL DEFAULT NULL COMMENT '建议供应商ID',
  `materials` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '物料清单JSON(含单价)',
  `total_amount` decimal(12, 2) NULL DEFAULT NULL COMMENT '总金额',
  `status` tinyint NULL DEFAULT 0 COMMENT '状态: 0草稿 1待确认 2通过 3驳回',
  `audit_opinion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '审核意见',
  `audit_user_id` bigint NULL DEFAULT NULL COMMENT '审核人ID',
  `audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `create_user_id` bigint NULL DEFAULT NULL COMMENT '创建人ID',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_plan_no`(`plan_no` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '采购方案表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of purchase_plan
-- ----------------------------

-- ----------------------------
-- Table structure for purchase_request
-- ----------------------------
DROP TABLE IF EXISTS `purchase_request`;
CREATE TABLE `purchase_request`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `request_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '申请单号',
  `project_id` bigint NOT NULL COMMENT '项目ID',
  `applicant_id` bigint NOT NULL COMMENT '申请人ID',
  `expect_date` date NULL DEFAULT NULL COMMENT '期望到货日',
  `priority` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'normal' COMMENT '优先级: low,normal,high',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '申请说明',
  `materials` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '物料清单JSON',
  `attachments` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '附件JSON',
  `status` tinyint NULL DEFAULT 0 COMMENT '状态: 0草稿 1待审核 2通过 3驳回',
  `audit_opinion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '审核意见',
  `audit_user_id` bigint NULL DEFAULT NULL COMMENT '审核人ID',
  `audit_time` datetime NULL DEFAULT NULL COMMENT '审核时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_request_no`(`request_no` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '采购申请表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of purchase_request
-- ----------------------------
INSERT INTO `purchase_request` VALUES (1, 'PR1771728037352', 1, 3, '2026-02-27', 'normal', '需要水泥', '[{\"materialCode\":\"01\",\"materialName\":\"水泥\",\"specification\":\"2026\",\"material\":\"混凝土\",\"quantity\":1,\"unit\":\"袋\",\"image\":\"http://localhost:8080/uploads/2026/02/22/da561ef3-5fca-4afe-a3d1-21b27d282525.png\",\"remark\":\"\"}]', NULL, 2, '同意', 2, '2026-02-22 10:40:46', '2026-02-22 10:40:37', '2026-02-22 10:40:37', 0);
INSERT INTO `purchase_request` VALUES (2, 'PR1771728681002', 1, 3, '2026-02-17', 'normal', '1111', '[{\"materialCode\":\"1\",\"materialName\":\"1\",\"specification\":\"1\",\"material\":\"1\",\"quantity\":1,\"unit\":\"\",\"image\":\"\",\"remark\":\"1\"}]', NULL, 2, '同意', 2, '2026-02-22 10:51:48', '2026-02-22 10:51:21', '2026-02-22 10:51:21', 0);
INSERT INTO `purchase_request` VALUES (3, 'PR1771729701662', 1, 3, '2026-02-19', 'normal', '哈哈哈哈', '[{\"materialCode\":\"1\",\"materialName\":\"1\",\"specification\":\"1\",\"material\":\"1\",\"quantity\":1,\"unit\":\"个\",\"image\":\"\",\"remark\":\"1\"}]', NULL, 2, '同意', 2, '2026-02-22 11:08:33', '2026-02-22 11:08:21', '2026-02-22 11:08:21', 0);
INSERT INTO `purchase_request` VALUES (4, 'PR1771735640084', 1, 3, '2026-02-27', 'high', '哈哈哈', '[{\"materialCode\":\"1\",\"materialName\":\"1\",\"specification\":\"1\",\"material\":\"1\",\"quantity\":1,\"unit\":\"1\",\"image\":\"\",\"remark\":\"1\"}]', NULL, 2, '同意', 2, '2026-02-22 12:47:33', '2026-02-22 12:47:20', '2026-02-22 12:47:20', 0);
INSERT INTO `purchase_request` VALUES (5, 'PR1771739169503', 1, 3, '2026-02-24', 'normal', '翻新狼堡需要钢筋', '[{\"materialCode\":\"0101\",\"materialName\":\"钢筋\",\"specification\":\"01\",\"material\":\"钢筋\",\"quantity\":1,\"unit\":\"根\",\"image\":\"http://localhost:8080/uploads/2026/02/22/ada998cf-1904-4bca-802e-7c89724f0fca.png\",\"remark\":\"111\"}]', NULL, 2, '同意！ 请按规定采购', 2, '2026-02-22 13:46:46', '2026-02-22 13:46:09', '2026-02-22 13:46:09', 0);
INSERT INTO `purchase_request` VALUES (6, 'PR1771740440300', 1, 3, '2026-02-24', 'normal', '111', '[{\"materialCode\":\"1\",\"materialName\":\"1\",\"specification\":\"1\",\"material\":\"1\",\"quantity\":1,\"unit\":\"1\",\"image\":\"http://localhost:8080/uploads/2026/02/22/85055814-d3a3-42e8-944b-1f22c15936fb.jpg\",\"remark\":\"1\"}]', '', 1, NULL, NULL, NULL, '2026-02-22 14:07:20', '2026-02-22 14:07:20', 0);
INSERT INTO `purchase_request` VALUES (7, 'PR1771740699584', 1, 3, '2026-02-25', 'normal', '1', '[{\"materialCode\":\"1\",\"materialName\":\"1\",\"specification\":\"1\",\"material\":\"1\",\"quantity\":1,\"unit\":\"1\",\"image\":\"http://localhost:8080/uploads/2026/02/22/10426c03-297f-4d03-ba4a-6d32082ad0a1.png\",\"remark\":\"\"}]', '/uploads/2026/02/22/17247c81-0473-49a8-9711-23d4a456e823.pdf', 2, '同意', 2, '2026-02-22 14:12:04', '2026-02-22 14:11:39', '2026-02-22 14:11:39', 0);

-- ----------------------------
-- Table structure for supplier
-- ----------------------------
DROP TABLE IF EXISTS `supplier`;
CREATE TABLE `supplier`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '供应商名称',
  `contact_person` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系人',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '电话',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '地址',
  `business_license` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '营业执照',
  `id_card` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '身份证',
  `qualification` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '资质证书JSON',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态: 0禁用 1启用',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '供应商表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of supplier
-- ----------------------------
INSERT INTO `supplier` VALUES (1, '北京机械设备有限公司', '张三', '13800138001', NULL, NULL, NULL, NULL, NULL, 1, '2026-02-22 10:37:51', '2026-02-22 10:37:51', 0);
INSERT INTO `supplier` VALUES (2, '上海材料科技有限公司', '李四', '13800138002', NULL, NULL, NULL, NULL, NULL, 1, '2026-02-22 10:37:51', '2026-02-22 11:04:15', 1);
INSERT INTO `supplier` VALUES (3, '武汉市荻荻为光科技有限公司', '王大炮', '19539057575', '3494956829@qq.com', '武汉市洪山区', NULL, NULL, NULL, 1, '2026-02-22 11:07:19', '2026-02-22 11:07:19', 0);

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `config_key` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '配置键',
  `config_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '配置值',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '描述',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_config_key`(`config_key` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, 'system_name', '制造业采购管理系统', '系统名称', '2026-02-22 10:37:51', '2026-02-22 10:37:51');
INSERT INTO `sys_config` VALUES (2, 'system_logo', '', '系统Logo', '2026-02-22 10:37:51', '2026-02-22 10:37:51');
INSERT INTO `sys_config` VALUES (3, 'login_background', '', '登录背景', '2026-02-22 10:37:51', '2026-02-22 10:37:51');
INSERT INTO `sys_config` VALUES (4, 'site_icon', '', '网站图标', '2026-02-22 10:37:51', '2026-02-22 10:37:51');

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码',
  `real_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '真实姓名',
  `role` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色: admin,project_manager,purchaser,supplier',
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '头像',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '电话',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` tinyint NULL DEFAULT 1 COMMENT '状态: 0禁用 1启用',
  `supplier_id` bigint NULL DEFAULT NULL COMMENT '供应商ID(角色为供应商时)',
  `last_login_time` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted` tinyint NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'admin', '123456', '系统管理员', 'admin', NULL, NULL, NULL, 1, NULL, NULL, '2026-02-22 10:37:51', '2026-02-22 10:37:51', 0);
INSERT INTO `sys_user` VALUES (2, 'pm', '123456', '项目经理', 'project_manager', NULL, NULL, NULL, 1, NULL, NULL, '2026-02-22 10:37:51', '2026-02-22 10:37:51', 0);
INSERT INTO `sys_user` VALUES (3, 'purchaser', '123456', '采购员', 'purchaser', NULL, NULL, NULL, 1, NULL, NULL, '2026-02-22 10:37:51', '2026-02-22 10:37:51', 0);
INSERT INTO `sys_user` VALUES (4, 'supplier1', '123456', '供应商1', 'supplier', NULL, NULL, NULL, 1, NULL, NULL, '2026-02-22 10:37:51', '2026-02-22 10:37:51', 0);
INSERT INTO `sys_user` VALUES (5, 'WHDDWG', '123456', '张大炮', 'supplier', NULL, '19539057575', '3494956829@qq.com', 1, 3, NULL, '2026-02-22 11:07:53', '2026-02-22 11:07:53', 0);

SET FOREIGN_KEY_CHECKS = 1;
