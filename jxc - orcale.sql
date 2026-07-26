-- ============================================================
-- Oracle完整建库脚本
-- ============================================================

BEGIN
  FOR t IN (
    SELECT table_name FROM user_tables
    WHERE table_name IN (
      'PERSISTENT_LOGINS','T_CUSTOMER','T_CUSTOMER_RETURN_LIST','T_CUSTOMER_RETURN_LIST_GOODS',
      'T_DAMAGE_LIST','T_DAMAGE_LIST_GOODS','T_GOODS','T_GOODS_TYPE','T_GOODS_UNIT','T_LOG',
      'T_MENU','T_OVERFLOW_LIST','T_OVERFLOW_LIST_GOODS','T_PURCHASE_LIST','T_PURCHASE_LIST_GOODS',
      'T_RETURN_LIST','T_RETURN_LIST_GOODS','T_ROLE','T_ROLE_MENU','T_SALE_LIST','T_SALE_LIST_GOODS',
      'T_SUPPLIER','T_USER','T_USER_ROLE'
    )
  ) LOOP
    EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
  END LOOP;
END;
/


DECLARE
  v_sql VARCHAR2(1000);
BEGIN
  FOR s IN (SELECT sequence_name FROM user_sequences
            WHERE sequence_name IN ('SEQ_PERSISTENT_LOGINS','SEQ_T_CUSTOMER','SEQ_T_CUSTOMER_RETURN_LIST','SEQ_T_CRL_GOODS',
                                   'SEQ_T_DAMAGE_LIST','SEQ_T_DAMAGE_LIST_GOODS','SEQ_T_GOODS','SEQ_T_GOODS_TYPE',
                                   'SEQ_T_GOODS_UNIT','SEQ_T_LOG','SEQ_T_MENU','SEQ_T_OVERFLOW_LIST','SEQ_T_OVERFLOW_LIST_GOODS',
                                   'SEQ_T_PURCHASE_LIST','SEQ_T_PURCHASE_LIST_GOODS','SEQ_T_RETURN_LIST','SEQ_T_RETURN_LIST_GOODS',
                                   'SEQ_T_ROLE','SEQ_T_ROLE_MENU','SEQ_T_SALE_LIST','SEQ_T_SALE_LIST_GOODS',
                                   'SEQ_T_SUPPLIER','SEQ_T_USER','SEQ_T_USER_ROLE')) LOOP
    v_sql := 'DROP SEQUENCE '||s.sequence_name;
    EXECUTE IMMEDIATE v_sql;
  END LOOP;
EXCEPTION WHEN OTHERS THEN NULL;
END;
/
COMMIT;



-- 记住我登录表
CREATE TABLE persistent_logins (
  username  VARCHAR2(64) NOT NULL,
  series    VARCHAR2(64) NOT NULL,
  token     VARCHAR2(64) NOT NULL,
  last_used TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  PRIMARY KEY (series)
);

-- 客户表
CREATE TABLE t_customer (
  id       NUMBER(11) NOT NULL,
  address  VARCHAR2(300),
  contact  VARCHAR2(50),
  name     VARCHAR2(200),
  "NUMBER" VARCHAR2(50),
  remarks  VARCHAR2(1000),
  is_del   NUMBER(11),
  PRIMARY KEY (id)
);

-- 客户退货单表
CREATE TABLE t_customer_return_list (
  id                     NUMBER(11) NOT NULL,
  amount_paid            NUMBER NOT NULL,
  amount_payable         NUMBER NOT NULL,
  customer_return_date   DATE,
  customer_return_number VARCHAR2(100),
  remarks                VARCHAR2(1000),
  state                  NUMBER(11),
  user_id                NUMBER(11),
  customer_id            NUMBER(11),
  PRIMARY KEY (id)
);

-- 客户退货单商品表
CREATE TABLE t_customer_return_list_goods (
  id                     NUMBER(11) NOT NULL,
  code                   VARCHAR2(50),
  model                  VARCHAR2(50),
  name                   VARCHAR2(50),
  num                    NUMBER(11) NOT NULL,
  price                  NUMBER NOT NULL,
  total                  NUMBER NOT NULL,
  unit                   VARCHAR2(10),
  customer_return_list_id NUMBER(11),
  type_id                NUMBER(11),
  goods_id               NUMBER(11),
  PRIMARY KEY (id)
);

-- 报损单表
CREATE TABLE t_damage_list (
  id            NUMBER(11) NOT NULL,
  damage_date   DATE,
  damage_number VARCHAR2(100),
  remarks       VARCHAR2(1000),
  user_id       NUMBER(11),
  PRIMARY KEY (id)
);

-- 报损单商品表
CREATE TABLE t_damage_list_goods (
  id            NUMBER(11) NOT NULL,
  code          VARCHAR2(50),
  model         VARCHAR2(50),
  name          VARCHAR2(50),
  num           NUMBER(11) NOT NULL,
  price         NUMBER NOT NULL,
  total         NUMBER NOT NULL,
  unit          VARCHAR2(10),
  damage_list_id NUMBER(11),
  type_id       NUMBER(11),
  goods_id      NUMBER(11),
  PRIMARY KEY (id)
);

-- 商品表
CREATE TABLE t_goods (
  id                    NUMBER(11) NOT NULL,
  code                  VARCHAR2(50),
  inventory_quantity    NUMBER(11) NOT NULL,
  min_num               NUMBER(11) NOT NULL,
  model                 VARCHAR2(50),
  name                  VARCHAR2(100),  -- MySQL varchar(50) 按字符计，Oracle 默认按字节计，GBK 下 50 个汉字需 100 字节
  producer              VARCHAR2(200),
  purchasing_price      NUMBER NOT NULL,
  remarks               VARCHAR2(1000),
  selling_price         NUMBER NOT NULL,
  unit                  VARCHAR2(10),
  type_id               NUMBER(11),
  state                 NUMBER(11) NOT NULL,
  last_purchasing_price NUMBER NOT NULL,
  is_del                NUMBER(11),
  PRIMARY KEY (id)
);

-- 商品类别表
CREATE TABLE t_goods_type (
  id    NUMBER(11) NOT NULL,
  name  VARCHAR2(50),
  p_id  NUMBER(11),
  state NUMBER(11),
  icon  VARCHAR2(100),
  PRIMARY KEY (id)
);

-- 商品单位表
CREATE TABLE t_goods_unit (
  id   NUMBER(11) NOT NULL,
  name VARCHAR2(10),
  PRIMARY KEY (id)
);

-- 日志表
CREATE TABLE t_log (
  id      NUMBER(11) NOT NULL,
  content VARCHAR2(1000),
  time    DATE,
  type    VARCHAR2(100),
  user_id NUMBER(11),
  PRIMARY KEY (id)
);

-- 菜单表
CREATE TABLE t_menu (
  id        NUMBER(11) NOT NULL,
  icon      VARCHAR2(100),
  name      VARCHAR2(50),
  state     NUMBER(11),
  url       VARCHAR2(200),
  p_id      NUMBER(11),
  acl_value VARCHAR2(255),
  grade     NUMBER(9),
  is_del    NUMBER(11) DEFAULT 0,
  PRIMARY KEY (id)
);

-- 报溢单表
CREATE TABLE t_overflow_list (
  id             NUMBER(11) NOT NULL,
  overflow_date  DATE,
  overflow_number VARCHAR2(100),
  remarks        VARCHAR2(1000),
  user_id        NUMBER(11),
  PRIMARY KEY (id)
);

-- 报溢单商品表
CREATE TABLE t_overflow_list_goods (
  id              NUMBER(11) NOT NULL,
  code            VARCHAR2(50),
  model           VARCHAR2(50),
  name            VARCHAR2(50),
  num             NUMBER(11) NOT NULL,
  price           NUMBER NOT NULL,
  total           NUMBER NOT NULL,
  unit            VARCHAR2(10),
  overflow_list_id NUMBER(11),
  type_id         NUMBER(11),
  goods_id        NUMBER(11),
  PRIMARY KEY (id)
);

-- 进货单
CREATE TABLE t_purchase_list (
  id              NUMBER(11) NOT NULL,
  amount_paid     NUMBER NOT NULL,
  amount_payable  NUMBER NOT NULL,
  purchase_date   DATE,
  remarks         VARCHAR2(1000),
  state           NUMBER(11) NOT NULL,
  purchase_number VARCHAR2(100),
  supplier_id     NUMBER(11),
  user_id         NUMBER(11),
  PRIMARY KEY (id)
);

-- 进货单商品表
CREATE TABLE t_purchase_list_goods (
  id              NUMBER(11) NOT NULL,
  code            VARCHAR2(50),
  model           VARCHAR2(50),
  name            VARCHAR2(50),
  num             NUMBER(11) NOT NULL,
  price           NUMBER NOT NULL,
  total           NUMBER NOT NULL,
  unit            VARCHAR2(10),
  purchase_list_id NUMBER(11),
  type_id         NUMBER(11),
  goods_id        NUMBER(11),
  PRIMARY KEY (id)
);

-- 退货单表
CREATE TABLE t_return_list (
  id            NUMBER(11) NOT NULL,
  amount_paid   NUMBER NOT NULL,
  amount_payable NUMBER NOT NULL,
  remarks       VARCHAR2(1000),
  return_date   DATE,
  return_number VARCHAR2(100),
  state         NUMBER(11) NOT NULL,
  supplier_id   NUMBER(11),
  user_id       NUMBER(11),
  PRIMARY KEY (id)
);

-- 退货单商品表
CREATE TABLE t_return_list_goods (
  id            NUMBER(11) NOT NULL,
  code          VARCHAR2(50),
  model         VARCHAR2(50),
  name          VARCHAR2(50),
  num           NUMBER(11) NOT NULL,
  price         NUMBER NOT NULL,
  total         NUMBER NOT NULL,
  unit          VARCHAR2(10),
  return_list_id NUMBER(11),
  type_id       NUMBER(11),
  goods_id      NUMBER(11),
  PRIMARY KEY (id)
);

-- 角色表
CREATE TABLE t_role (
  id      NUMBER(11) NOT NULL,
  bz      VARCHAR2(1000),
  name    VARCHAR2(50),
  remarks VARCHAR2(1000),
  is_del  NUMBER(11) DEFAULT 0,
  PRIMARY KEY (id)
);

-- 角色菜单表
CREATE TABLE t_role_menu (
  id      NUMBER(11) NOT NULL,
  menu_id NUMBER(11),
  role_id NUMBER(11),
  PRIMARY KEY (id)
);

-- 销售单表
CREATE TABLE t_sale_list (
  id            NUMBER(11) NOT NULL,
  amount_paid   NUMBER NOT NULL,
  amount_payable NUMBER NOT NULL,
  remarks       VARCHAR2(1000),
  sale_date     DATE,
  sale_number   VARCHAR2(100),
  state         NUMBER(11),
  user_id       NUMBER(11),
  customer_id   NUMBER(11),
  PRIMARY KEY (id)
);

-- 销售单商品表
CREATE TABLE t_sale_list_goods (
  id          NUMBER(11) NOT NULL,
  code        VARCHAR2(50),
  model       VARCHAR2(50),
  name        VARCHAR2(50),
  num         NUMBER(11) NOT NULL,
  price       NUMBER NOT NULL,
  total       NUMBER NOT NULL,
  unit        VARCHAR2(10),
  sale_list_id NUMBER(11),
  type_id     NUMBER(11),
  goods_id    NUMBER(11),
  PRIMARY KEY (id)
);

-- 供应商表
CREATE TABLE t_supplier (
  id       NUMBER(11) NOT NULL,
  address  VARCHAR2(300),
  contact  VARCHAR2(50),
  name     VARCHAR2(200),
  "NUMBER" VARCHAR2(50),
  remarks  VARCHAR2(1000),
  is_del   NUMBER(11),
  PRIMARY KEY (id)
);

-- 用户表
CREATE TABLE t_user (
  id        NUMBER(11) NOT NULL,
  bz        VARCHAR2(100),
  password  VARCHAR2(255),
  true_name VARCHAR2(50),
  user_name VARCHAR2(50),
  remarks   VARCHAR2(1000),
  is_del    NUMBER(11) DEFAULT 0,
  PRIMARY KEY (id)
);

-- 用户角色表
CREATE TABLE t_user_role (
  id      NUMBER(11) NOT NULL,
  role_id NUMBER(11),
  user_id NUMBER(11),
  PRIMARY KEY (id)
);

-- ============================================================
-- 四、表和字段注释
-- ============================================================
COMMENT ON TABLE  persistent_logins IS '记住我登录表';
COMMENT ON COLUMN persistent_logins.username IS '用户名';
COMMENT ON COLUMN persistent_logins.series IS '系列标识（主键）';
COMMENT ON COLUMN persistent_logins.token IS '令牌';
COMMENT ON COLUMN persistent_logins.last_used IS '最后使用时间';

COMMENT ON TABLE  t_customer IS '客户表';
COMMENT ON COLUMN t_customer.id IS '主键';
COMMENT ON COLUMN t_customer.address IS '客户地址';
COMMENT ON COLUMN t_customer.contact IS '联系人';
COMMENT ON COLUMN t_customer.name IS '客户名称';
COMMENT ON COLUMN t_customer."NUMBER" IS '客户联系电话';
COMMENT ON COLUMN t_customer.remarks IS '备注';
COMMENT ON COLUMN t_customer.is_del IS '是否删除';

COMMENT ON TABLE  t_customer_return_list IS '客户退货单表';
COMMENT ON COLUMN t_customer_return_list.id IS '主键';
COMMENT ON COLUMN t_customer_return_list.amount_paid IS '实付金额';
COMMENT ON COLUMN t_customer_return_list.amount_payable IS '应付金额';
COMMENT ON COLUMN t_customer_return_list.customer_return_date IS '退货日期';
COMMENT ON COLUMN t_customer_return_list.customer_return_number IS '退货单号';
COMMENT ON COLUMN t_customer_return_list.remarks IS '备注';
COMMENT ON COLUMN t_customer_return_list.state IS '交易状态';
COMMENT ON COLUMN t_customer_return_list.user_id IS '操作用户';
COMMENT ON COLUMN t_customer_return_list.customer_id IS '客户id';

COMMENT ON TABLE  t_customer_return_list_goods IS '客户退货单商品表';
COMMENT ON COLUMN t_customer_return_list_goods.id IS '主键';
COMMENT ON COLUMN t_customer_return_list_goods.code IS '商品编码';
COMMENT ON COLUMN t_customer_return_list_goods.model IS '商品型号';
COMMENT ON COLUMN t_customer_return_list_goods.name IS '商品名称';
COMMENT ON COLUMN t_customer_return_list_goods.num IS '数量';
COMMENT ON COLUMN t_customer_return_list_goods.price IS '价格';
COMMENT ON COLUMN t_customer_return_list_goods.total IS '总价';
COMMENT ON COLUMN t_customer_return_list_goods.unit IS '单位';
COMMENT ON COLUMN t_customer_return_list_goods.customer_return_list_id IS '客户退货id';
COMMENT ON COLUMN t_customer_return_list_goods.type_id IS '商品类别';
COMMENT ON COLUMN t_customer_return_list_goods.goods_id IS '商品id';

COMMENT ON TABLE  t_damage_list IS '报损单表';
COMMENT ON COLUMN t_damage_list.id IS '主键';
COMMENT ON COLUMN t_damage_list.damage_date IS '报损日期';
COMMENT ON COLUMN t_damage_list.damage_number IS '报损单号';
COMMENT ON COLUMN t_damage_list.remarks IS '备注';
COMMENT ON COLUMN t_damage_list.user_id IS '操作用户id';

COMMENT ON TABLE  t_damage_list_goods IS '报损单商品表';
COMMENT ON COLUMN t_damage_list_goods.id IS '主键';
COMMENT ON COLUMN t_damage_list_goods.code IS '商品编码';
COMMENT ON COLUMN t_damage_list_goods.model IS '型号';
COMMENT ON COLUMN t_damage_list_goods.name IS '商品名称';
COMMENT ON COLUMN t_damage_list_goods.num IS '数量';
COMMENT ON COLUMN t_damage_list_goods.price IS '价格';
COMMENT ON COLUMN t_damage_list_goods.total IS '总价';
COMMENT ON COLUMN t_damage_list_goods.unit IS '单位';
COMMENT ON COLUMN t_damage_list_goods.damage_list_id IS '报损单id';
COMMENT ON COLUMN t_damage_list_goods.type_id IS '商品类别id';
COMMENT ON COLUMN t_damage_list_goods.goods_id IS '商品id';

COMMENT ON TABLE  t_goods IS '商品表';
COMMENT ON COLUMN t_goods.id IS '主键';
COMMENT ON COLUMN t_goods.code IS '商品编码';
COMMENT ON COLUMN t_goods.inventory_quantity IS '库存数量';
COMMENT ON COLUMN t_goods.min_num IS '库存下限';
COMMENT ON COLUMN t_goods.model IS '商品型号';
COMMENT ON COLUMN t_goods.name IS '商品名称';
COMMENT ON COLUMN t_goods.producer IS '生产产商';
COMMENT ON COLUMN t_goods.purchasing_price IS '采购价格';
COMMENT ON COLUMN t_goods.remarks IS '备注';
COMMENT ON COLUMN t_goods.selling_price IS '出售价格';
COMMENT ON COLUMN t_goods.unit IS '商品单位';
COMMENT ON COLUMN t_goods.type_id IS '商品类别';
COMMENT ON COLUMN t_goods.state IS '商品状态';
COMMENT ON COLUMN t_goods.last_purchasing_price IS '上次采购价格';
COMMENT ON COLUMN t_goods.is_del IS '是否删除';

COMMENT ON TABLE  t_goods_type IS '商品类别表';
COMMENT ON COLUMN t_goods_type.id IS '主键';
COMMENT ON COLUMN t_goods_type.name IS '类别名';
COMMENT ON COLUMN t_goods_type.p_id IS '父级类别id';
COMMENT ON COLUMN t_goods_type.state IS '节点类型';
COMMENT ON COLUMN t_goods_type.icon IS '节点图标';

COMMENT ON TABLE  t_goods_unit IS '商品单位表';
COMMENT ON COLUMN t_goods_unit.id IS '主键';
COMMENT ON COLUMN t_goods_unit.name IS '单位名';

COMMENT ON TABLE  t_log IS '日志表';
COMMENT ON COLUMN t_log.id IS '主键';
COMMENT ON COLUMN t_log.content IS '日志内容';
COMMENT ON COLUMN t_log.time IS '操作时间';
COMMENT ON COLUMN t_log.type IS '日志类型';
COMMENT ON COLUMN t_log.user_id IS '操作用户id';

COMMENT ON TABLE  t_menu IS '菜单表';
COMMENT ON COLUMN t_menu.id IS '主键';
COMMENT ON COLUMN t_menu.icon IS '菜单图标';
COMMENT ON COLUMN t_menu.name IS '菜单名称';
COMMENT ON COLUMN t_menu.state IS '节点类型';
COMMENT ON COLUMN t_menu.url IS '菜单url';
COMMENT ON COLUMN t_menu.p_id IS '上级菜单id';
COMMENT ON COLUMN t_menu.acl_value IS '权限码';
COMMENT ON COLUMN t_menu.grade IS '菜单层级';
COMMENT ON COLUMN t_menu.is_del IS '是否删除';

COMMENT ON TABLE  t_overflow_list IS '报溢单表';
COMMENT ON COLUMN t_overflow_list.id IS '主键';
COMMENT ON COLUMN t_overflow_list.overflow_date IS '报溢日期';
COMMENT ON COLUMN t_overflow_list.overflow_number IS '报溢单号';
COMMENT ON COLUMN t_overflow_list.remarks IS '备注';
COMMENT ON COLUMN t_overflow_list.user_id IS '操作用户id';

COMMENT ON TABLE  t_overflow_list_goods IS '报溢单商品表';
COMMENT ON COLUMN t_overflow_list_goods.id IS '主键';
COMMENT ON COLUMN t_overflow_list_goods.code IS '编码';
COMMENT ON COLUMN t_overflow_list_goods.model IS '型号';
COMMENT ON COLUMN t_overflow_list_goods.name IS '商品名';
COMMENT ON COLUMN t_overflow_list_goods.num IS '数量';
COMMENT ON COLUMN t_overflow_list_goods.price IS '价格';
COMMENT ON COLUMN t_overflow_list_goods.total IS '总价';
COMMENT ON COLUMN t_overflow_list_goods.unit IS '单位';
COMMENT ON COLUMN t_overflow_list_goods.overflow_list_id IS '报溢单id';
COMMENT ON COLUMN t_overflow_list_goods.type_id IS '商品类别id';
COMMENT ON COLUMN t_overflow_list_goods.goods_id IS '商品id';

COMMENT ON TABLE  t_purchase_list IS '进货单';
COMMENT ON COLUMN t_purchase_list.id IS '主键';
COMMENT ON COLUMN t_purchase_list.amount_paid IS '实付金额';
COMMENT ON COLUMN t_purchase_list.amount_payable IS '应付金额';
COMMENT ON COLUMN t_purchase_list.purchase_date IS '进货日期';
COMMENT ON COLUMN t_purchase_list.remarks IS '备注';
COMMENT ON COLUMN t_purchase_list.state IS '交易状态';
COMMENT ON COLUMN t_purchase_list.purchase_number IS '进货单号';
COMMENT ON COLUMN t_purchase_list.supplier_id IS '供应商';
COMMENT ON COLUMN t_purchase_list.user_id IS '操作用户';

COMMENT ON TABLE  t_purchase_list_goods IS '进货单商品表';
COMMENT ON COLUMN t_purchase_list_goods.id IS '主键';
COMMENT ON COLUMN t_purchase_list_goods.code IS '商品编码';
COMMENT ON COLUMN t_purchase_list_goods.model IS '商品型号';
COMMENT ON COLUMN t_purchase_list_goods.name IS '商品名称';
COMMENT ON COLUMN t_purchase_list_goods.num IS '数量';
COMMENT ON COLUMN t_purchase_list_goods.price IS '单价';
COMMENT ON COLUMN t_purchase_list_goods.total IS '总价';
COMMENT ON COLUMN t_purchase_list_goods.unit IS '商品单位';
COMMENT ON COLUMN t_purchase_list_goods.purchase_list_id IS '进货单id';
COMMENT ON COLUMN t_purchase_list_goods.type_id IS '商品类别';
COMMENT ON COLUMN t_purchase_list_goods.goods_id IS '商品id';

COMMENT ON TABLE  t_return_list IS '退货单表';
COMMENT ON COLUMN t_return_list.id IS '主键';
COMMENT ON COLUMN t_return_list.amount_paid IS '实付金额';
COMMENT ON COLUMN t_return_list.amount_payable IS '应付金额';
COMMENT ON COLUMN t_return_list.remarks IS '备注';
COMMENT ON COLUMN t_return_list.return_date IS '退货日期';
COMMENT ON COLUMN t_return_list.return_number IS '退货单号';
COMMENT ON COLUMN t_return_list.state IS '交易状态';
COMMENT ON COLUMN t_return_list.supplier_id IS '供应商';
COMMENT ON COLUMN t_return_list.user_id IS '操作用户';

COMMENT ON TABLE  t_return_list_goods IS '退货单商品表';
COMMENT ON COLUMN t_return_list_goods.id IS '主键';
COMMENT ON COLUMN t_return_list_goods.code IS '商品编码';
COMMENT ON COLUMN t_return_list_goods.model IS '商品型号';
COMMENT ON COLUMN t_return_list_goods.name IS '商品名称';
COMMENT ON COLUMN t_return_list_goods.num IS '数量';
COMMENT ON COLUMN t_return_list_goods.price IS '单价';
COMMENT ON COLUMN t_return_list_goods.total IS '总价';
COMMENT ON COLUMN t_return_list_goods.unit IS '单位';
COMMENT ON COLUMN t_return_list_goods.return_list_id IS '退货单id';
COMMENT ON COLUMN t_return_list_goods.type_id IS '商品类别';
COMMENT ON COLUMN t_return_list_goods.goods_id IS '商品id';

COMMENT ON TABLE  t_role IS '角色表';
COMMENT ON COLUMN t_role.id IS '主键';
COMMENT ON COLUMN t_role.bz IS '备注';
COMMENT ON COLUMN t_role.name IS '角色名';
COMMENT ON COLUMN t_role.remarks IS '描述';
COMMENT ON COLUMN t_role.is_del IS '是否删除';

COMMENT ON TABLE  t_role_menu IS '角色菜单表';
COMMENT ON COLUMN t_role_menu.id IS '主键';
COMMENT ON COLUMN t_role_menu.menu_id IS '菜单id';
COMMENT ON COLUMN t_role_menu.role_id IS '角色id';

COMMENT ON TABLE  t_sale_list IS '销售单表';
COMMENT ON COLUMN t_sale_list.id IS '主键';
COMMENT ON COLUMN t_sale_list.amount_paid IS '实付金额';
COMMENT ON COLUMN t_sale_list.amount_payable IS '应付金额';
COMMENT ON COLUMN t_sale_list.remarks IS '备注';
COMMENT ON COLUMN t_sale_list.sale_date IS '销售日期';
COMMENT ON COLUMN t_sale_list.sale_number IS '销售单号';
COMMENT ON COLUMN t_sale_list.state IS '交易状态';
COMMENT ON COLUMN t_sale_list.user_id IS '操作用户';
COMMENT ON COLUMN t_sale_list.customer_id IS '客户id';

COMMENT ON TABLE  t_sale_list_goods IS '销售单商品表';
COMMENT ON COLUMN t_sale_list_goods.id IS '主键';
COMMENT ON COLUMN t_sale_list_goods.code IS '商品编码';
COMMENT ON COLUMN t_sale_list_goods.model IS '商品型号';
COMMENT ON COLUMN t_sale_list_goods.name IS '商品名称';
COMMENT ON COLUMN t_sale_list_goods.num IS '数量';
COMMENT ON COLUMN t_sale_list_goods.price IS '单价';
COMMENT ON COLUMN t_sale_list_goods.total IS '总价';
COMMENT ON COLUMN t_sale_list_goods.unit IS '单位';
COMMENT ON COLUMN t_sale_list_goods.sale_list_id IS '销售单';
COMMENT ON COLUMN t_sale_list_goods.type_id IS '商品类别';
COMMENT ON COLUMN t_sale_list_goods.goods_id IS '商品id';

COMMENT ON TABLE  t_supplier IS '供应商表';
COMMENT ON COLUMN t_supplier.id IS '主键';
COMMENT ON COLUMN t_supplier.address IS '联系地址';
COMMENT ON COLUMN t_supplier.contact IS '联系人';
COMMENT ON COLUMN t_supplier.name IS '供应商名称';
COMMENT ON COLUMN t_supplier."NUMBER" IS '联系电话';
COMMENT ON COLUMN t_supplier.remarks IS '备注';
COMMENT ON COLUMN t_supplier.is_del IS '是否删除';

COMMENT ON TABLE  t_user IS '用户表';
COMMENT ON COLUMN t_user.id IS '主键id';
COMMENT ON COLUMN t_user.bz IS '备注名';
COMMENT ON COLUMN t_user.password IS '密码';
COMMENT ON COLUMN t_user.true_name IS '真实姓名';
COMMENT ON COLUMN t_user.user_name IS '用户名';
COMMENT ON COLUMN t_user.remarks IS '备注';
COMMENT ON COLUMN t_user.is_del IS '是否删除';

COMMENT ON TABLE  t_user_role IS '用户角色表';
COMMENT ON COLUMN t_user_role.id IS '主键';
COMMENT ON COLUMN t_user_role.role_id IS '角色id';
COMMENT ON COLUMN t_user_role.user_id IS '用户id';

-- ============================================================
-- 五、插入数据
-- 注意：Oracle 中空字符串 '' 会自动转为 NULL，属于正常现象
-- ============================================================


-- 记住我登录表（persistent_logins）数据
INSERT INTO persistent_logins VALUES ('admin', '2eYiRK+p0882pdtogwEYqQ==', 'biRZCWsBdUSPbJ8K5siEYA==', TO_DATE('2022-03-12 10:51:53','YYYY-MM-DD HH24:MI:SS'));

-- 客户表（t_customer）数据
INSERT INTO t_customer VALUES (1, '福州新弯曲5号', '小李子', '福州艾玛超市', '2132-23213421', '', 0);
INSERT INTO t_customer VALUES (2, '天津兴达大街888号', '小张', '天津王大连锁酒店', '23432222311', '优质客户', 0);
INSERT INTO t_customer VALUES (3, '大凉山妥洛村', '小爱', '大凉山希望小学', '233243211', '照顾客户2', 1);
INSERT INTO t_customer VALUES (4, '南通通州新金路888号', '王二小', '南通通州综艺集团', '1832132321', '', 1);
INSERT INTO t_customer VALUES (5, '12321', 'test', 'test', '33', NULL, 1);
INSERT INTO t_customer VALUES (6, '黑龙江省绥化市', '吴彦祖', '黄天禹', '1', NULL, 1);
INSERT INTO t_customer VALUES (7, '成华大道', '吴先生', '吴彦祖超市', '562119139', NULL, 0);
INSERT INTO t_customer VALUES (8, '小鸡岛', '柒', '五六七五星级旅店', '36287738', NULL, 0);
INSERT INTO t_customer VALUES (9, '我也不知道啊', '皮卡丘', '可达鸭有限公司', '4008208820', NULL, 0);

-- 客户退货单表（t_customer_return_list）数据
INSERT INTO t_customer_return_list VALUES (2, 2200, 2200, TO_DATE('2017-10-27 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'XT201710270001', 'cc', 1, 1, 3);
INSERT INTO t_customer_return_list VALUES (3, 4514, 4514, TO_DATE('2017-10-28 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'XT201710280001', 'cc', 1, 1, 3);
INSERT INTO t_customer_return_list VALUES (4, 4400, 4400, TO_DATE('2017-10-30 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'XT201710300001', 'cc', 1, 1, 3);
INSERT INTO t_customer_return_list VALUES (5, 139, 139, TO_DATE('2017-10-30 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'XT201710300002', 'cc', 1, 1, 2);
INSERT INTO t_customer_return_list VALUES (6, 38, 38, TO_DATE('2017-11-03 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'XT201711030001', 'cc', 1, 1, 2);
INSERT INTO t_customer_return_list VALUES (7, 161, 161, TO_DATE('2022-01-22 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'XT202201210001', '', 1, 1, 2);

-- 客户退货单商品表（t_customer_return_list_goods）数据
INSERT INTO t_customer_return_list_goods VALUES (3, '0002', 'Note8', '华为荣耀Note8', 1, 2200, 2200, '台', 2, 16, 2);
INSERT INTO t_customer_return_list_goods VALUES (4, '0002', 'Note8', '华为荣耀Note8', 2, 2200, 4400, '台', 3, 16, 2);
INSERT INTO t_customer_return_list_goods VALUES (5, '0003', '500g装', '野生东北黑木耳', 3, 38, 114, '袋', 3, 11, 11);
INSERT INTO t_customer_return_list_goods VALUES (6, '0002', 'Note8', '华为荣耀Note8', 2, 2200, 4400, '台', 4, 16, 2);
INSERT INTO t_customer_return_list_goods VALUES (7, '0007', '500g装', '吉利人家牛肉味蛋糕', 2, 10, 20, '袋', 5, 11, 15);
INSERT INTO t_customer_return_list_goods VALUES (8, '0009', '240g装', '休闲零食坚果特产精品干果无漂白大个开心果', 3, 33, 99, '袋', 5, 11, 17);
INSERT INTO t_customer_return_list_goods VALUES (9, '0010', '250g装', '劲仔小鱼干', 1, 20, 20, '袋', 5, 11, 18);
INSERT INTO t_customer_return_list_goods VALUES (10, '0003', '500g装', '野生东北黑木耳', 1, 38, 38, '袋', 6, 11, 11);
INSERT INTO t_customer_return_list_goods VALUES (11, '0003', '500g装', '野生东北黑木耳', 7, 23, 161, '袋', 7, 11, 11);

-- 报损单表（t_damage_list）数据
INSERT INTO t_damage_list VALUES (3, TO_DATE('2017-10-27 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'BS201710270001', 'cc', 1);
INSERT INTO t_damage_list VALUES (4, TO_DATE('2017-10-27 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'BS201710270002', 'cc', 1);
INSERT INTO t_damage_list VALUES (5, TO_DATE('2017-11-03 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'BS201711030001', '', 1);
INSERT INTO t_damage_list VALUES (6, TO_DATE('2021-03-04 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'BS202103040001', '乐字节', 1);
INSERT INTO t_damage_list VALUES (12, TO_DATE('2022-01-22 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'BS202201220001', '', 1);
INSERT INTO t_damage_list VALUES (13, TO_DATE('2022-01-22 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'BS202201220001', '', 1);

-- 报损单商品表（t_damage_list_goods）数据
INSERT INTO t_damage_list_goods VALUES (4, '0003', '500g装', '野生东北黑木耳', 2, 23, 46, '袋', 3, 11, 11);
INSERT INTO t_damage_list_goods VALUES (5, '0006', '300g装', '冰糖金桔干', 2, 5, 10, '盒', 3, 11, 14);
INSERT INTO t_damage_list_goods VALUES (6, '0003', '500g装', '野生东北黑木耳', 2, 23, 46, '袋', 4, 11, 11);
INSERT INTO t_damage_list_goods VALUES (7, '0005', '散装500克', '麦片燕麦巧克力', 32, 8, 256, '袋', 4, 11, 13);
INSERT INTO t_damage_list_goods VALUES (8, '0007', '500g装', '吉利人家牛肉味蛋糕', 2, 4.5, 9, '袋', 4, 11, 15);
INSERT INTO t_damage_list_goods VALUES (9, '0002', 'Note8', '华为荣耀Note8', 1, 2220, 2220, '台', 5, 16, 2);
INSERT INTO t_damage_list_goods VALUES (10, '0002', 'Note8', '华为荣耀Note8', 20, 2220, 44400, '台', 6, 16, 2);

-- 商品表（t_goods）数据
INSERT INTO t_goods VALUES (1, '0001', 182, 1000, '红色装', '陶华碧老干妈香辣脆油辣椒', '贵州省贵阳南明老干妈风味食品有限公司', 6.32, '好卖', 8.5, '13', 10, 2, 8.5, 0);
INSERT INTO t_goods VALUES (2, '0002', 152, 400, 'Note8', '华为荣耀Note8', '华为计算机系统有限公司', 1950.05, '热销', 2200, '5', 16, 2, 2220, 0);
INSERT INTO t_goods VALUES (11, '0003', 2902, 400, '500g装', '野生东北黑木耳', '辉南县博康土特产有限公司', 23, '够黑2', 38, '2', 11, 2, 23, 0);
INSERT INTO t_goods VALUES (12, '0004', 329, 300, '2斤装', '新疆红枣', '沧州铭鑫食品有限公司', 13, '好吃', 25, '2', 10, 2, 13, 0);
INSERT INTO t_goods VALUES (13, '0005', 55, 1000, '散装500克', '麦片燕麦巧克力', '福建省麦德好食品工业有限公司', 8, 'Goods', 15, '2', 11, 2, 8, 0);
INSERT INTO t_goods VALUES (14, '0006', 36, 1999, '300g装', '冰糖金桔干', '揭西县同心食品有限公司', 5.1, '', 13, '3', 11, 2, 5, 0);
INSERT INTO t_goods VALUES (15, '0007', 100651, 400, '500g装', '吉利人家牛肉味蛋糕', '合肥吉利人家食品有限公司', 4.5, 'good', 10, '2', 11, 2, 4.5, 0);
INSERT INTO t_goods VALUES (16, '0008', 196, 500, '128g装', '奕森奶油桃肉蜜饯果脯果干桃肉干休闲零食品', '潮州市潮安区正大食品有限公司', 3, '', 10, '3', 11, 2, 3, 0);
INSERT INTO t_goods VALUES (17, '0009', 365, 1000, '240g装', '休闲零食坚果特产精品干果无漂白大个开心果', '石家庄博群食品有限公司', 20, '', 33, '2', 11, 2, 20, 0);
INSERT INTO t_goods VALUES (18, '0010', 10, 300, '250g装', '劲仔小鱼干', '湖南省华文食品有限公司', 12, '', 20, '2', 11, 2, 12, 0);
INSERT INTO t_goods VALUES (19, '0011', 11, 300, '198g装', '山楂条', '临朐县七贤升利食品厂', 3.2, '', 10, '2', 11, 0, 3.2, 0);
INSERT INTO t_goods VALUES (20, '0012', 22, 200, '500g装', '大乌梅干', '长春市鼎丰真食品有限责任公司', 20, '', 25, '2', 11, 0, 20, 0);
INSERT INTO t_goods VALUES (21, '0013', 400, 100, '250g装', '手工制作芝麻香酥麻通', '桂林兰雨食品有限公司', 3, '', 8, '2', 11, 2, 3, 0);
INSERT INTO t_goods VALUES (22, '0014', 12, 200, '250g装', '美国青豆原味 蒜香', '菲律宾', 5, '', 8, '2', 11, 2, 5, 0);
INSERT INTO t_goods VALUES (24, '0015', -3, 100, 'X', ' iPhone X', 'xx2', 8000, 'xxx2', 9500, '5', 16, 2, 8000, 0);
INSERT INTO t_goods VALUES (26, '0017', -1, 100, 'ILCE-A6000L', 'Sony/索尼 ILCE-A6000L WIFI微单数码相机高清单电', 'xxx', 3000, 'xxx', 3650, '5', 15, 2, 3000, 0);
INSERT INTO t_goods VALUES (27, '0018', -1, 400, 'IXUS 285 HS', 'Canon/佳能 IXUS 285 HS 数码相机 2020万像素高清拍摄', 'xx', 800, 'xxx', 1299, '5', 15, 2, 800, 0);
INSERT INTO t_goods VALUES (28, '0019', 100, 300, 'Q8', 'Golden Field/金河田 Q8电脑音响台式多媒体家用音箱低音炮重低音', 'xxxx', 60, '', 129, '5', 17, 0, 60, 0);
INSERT INTO t_goods VALUES (29, '0020', 2, 50, '190WDPT', 'Haier/海尔冰箱BCD-190WDPT双门电冰箱大两门冷藏冷冻', 'cc', 1000, '', 1699, '5', 14, 0, 1000, 0);
INSERT INTO t_goods VALUES (30, '0021', 0, 320, '4A ', 'Xiaomi/小米 小米电视4A 32英寸 智能液晶平板电视机', 'cc', 700, '', 1199, '5', 12, 0, 700, 0);
INSERT INTO t_goods VALUES (31, '0022', 0, 40, 'XQB55-36SP', 'TCL XQB55-36SP 5.5公斤全自动波轮迷你小型洗衣机家用单脱抗菌', 'cc', 400, '', 729, '5', 13, 0, 400, 0);
INSERT INTO t_goods VALUES (32, '0023', 0, 1000, '80g*2', '台湾进口膨化零食品张君雅小妹妹日式串烧丸子80g*2', 'cc', 4, '', 15, '2', 9, 0, 4, 0);
INSERT INTO t_goods VALUES (33, '0024', 0, 10, 'A字裙', '卓图女装立领针织格子印花拼接高腰A字裙2017秋冬新款碎花连衣裙', 'cc', 168, '', 298, '11', 6, 0, 168, 0);
INSERT INTO t_goods VALUES (34, '0025', 0, 10, '三件套秋', '西服套装男三件套秋季新款商务修身职业正装男士西装新郎结婚礼服', 'cc', 189, '', 299, '11', 7, 0, 189, 0);
INSERT INTO t_goods VALUES (35, '0026', 0, 10, 'AFS JEEP', '加绒加厚正品AFS JEEP/战地吉普男大码长裤植绒保暖男士牛仔裤子', 'c', 60, '', 89, '12', 8, 0, 60, 0);
INSERT INTO t_goods VALUES (38, '0027', 0, 10, 'xxl', '男士马甲453455', '海澜之家', 50, '', 200, '1', 7, 0, 0, 0);

-- 商品类别表（t_goods_type）数据
INSERT INTO t_goods_type VALUES (1, '所有类别', -1, 1, 'icon-folderOpen');
INSERT INTO t_goods_type VALUES (2, '服饰', 1, 1, 'icon-folder');
INSERT INTO t_goods_type VALUES (3, '食品', 1, 1, 'icon-folder');
INSERT INTO t_goods_type VALUES (4, '家电', 1, 1, 'icon-folder');
INSERT INTO t_goods_type VALUES (5, '数码', 1, 1, 'icon-folder');
INSERT INTO t_goods_type VALUES (6, '连衣裙', 2, 0, 'icon-folder');
INSERT INTO t_goods_type VALUES (7, '男士西装', 2, 0, 'icon-folder');
INSERT INTO t_goods_type VALUES (8, '牛仔裤', 2, 0, 'icon-folder');
INSERT INTO t_goods_type VALUES (9, '进口食品', 3, 0, 'icon-folder');
INSERT INTO t_goods_type VALUES (10, '地方特产', 3, 0, 'icon-folder');
INSERT INTO t_goods_type VALUES (11, '休闲食品', 3, 0, 'icon-folder');
INSERT INTO t_goods_type VALUES (12, '电视机', 4, 0, 'icon-folder');
INSERT INTO t_goods_type VALUES (13, '洗衣机', 4, 0, 'icon-folder');
INSERT INTO t_goods_type VALUES (14, '冰箱', 4, 0, 'icon-folder');
INSERT INTO t_goods_type VALUES (15, '相机', 5, 0, 'icon-folder');
INSERT INTO t_goods_type VALUES (16, '手机', 5, 0, 'icon-folder');
INSERT INTO t_goods_type VALUES (17, '音箱', 5, 0, 'icon-folder');

-- 商品单位表（t_goods_unit）数据
INSERT INTO t_goods_unit VALUES (1, '个');
INSERT INTO t_goods_unit VALUES (2, '袋');
INSERT INTO t_goods_unit VALUES (3, '盒');
INSERT INTO t_goods_unit VALUES (4, '箱');
INSERT INTO t_goods_unit VALUES (5, '台');
INSERT INTO t_goods_unit VALUES (6, '包');
INSERT INTO t_goods_unit VALUES (11, '件');
INSERT INTO t_goods_unit VALUES (12, '条');
INSERT INTO t_goods_unit VALUES (13, '瓶');


-- 日志表（t_log）数据
INSERT INTO t_log VALUES (1911, '查询用户信息', TO_DATE('2017-10-26 19:47:31','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1912, '查询用户信息', TO_DATE('2017-10-26 19:47:31','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1913, '用户注销', TO_DATE('2017-10-26 19:47:40','YYYY-MM-DD HH24:MI:SS'), '注销操作', 1);
INSERT INTO t_log VALUES (1914, '用户登录', TO_DATE('2017-10-26 19:47:45','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (1915, '用户登录', TO_DATE('2017-10-26 19:56:16','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (1916, '用户登录', TO_DATE('2017-10-26 19:56:52','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (1917, '用户登录', TO_DATE('2017-10-26 19:59:18','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (1918, '用户登录', TO_DATE('2017-10-26 20:53:34','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (1919, '查询商品信息', TO_DATE('2017-10-26 20:54:41','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1920, '查询商品信息', TO_DATE('2017-10-26 20:54:41','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1921, '查询商品类别信息', TO_DATE('2017-10-26 20:54:45','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1922, '用户登录', TO_DATE('2017-10-27 08:39:36','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (1923, '查询商品信息', TO_DATE('2017-10-27 08:41:20','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1924, '查询商品信息', TO_DATE('2017-10-27 08:41:20','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1925, '用户登录', TO_DATE('2017-10-27 09:51:40','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (1926, '查询商品信息', TO_DATE('2017-10-27 09:52:54','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1927, '查询商品信息', TO_DATE('2017-10-27 09:52:54','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1928, '查询商品类别信息', TO_DATE('2017-10-27 09:53:34','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1929, '添加进货单', TO_DATE('2017-10-27 09:54:02','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (1930, '查询商品信息', TO_DATE('2017-10-27 09:54:03','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1931, '查询商品信息', TO_DATE('2017-10-27 09:54:03','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1932, '用户登录', TO_DATE('2017-10-27 09:54:58','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (1933, '查询商品信息', TO_DATE('2017-10-27 09:55:20','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1934, '查询商品信息', TO_DATE('2017-10-27 09:55:20','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1935, '查询商品类别信息', TO_DATE('2017-10-27 09:55:22','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1936, '添加进货单', TO_DATE('2017-10-27 09:55:33','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (1937, '查询商品信息', TO_DATE('2017-10-27 09:55:34','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1938, '查询商品信息', TO_DATE('2017-10-27 09:55:34','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1939, '用户登录', TO_DATE('2017-10-27 09:59:02','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (1940, '用户登录', TO_DATE('2017-10-27 10:03:30','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (1941, '查询商品信息', TO_DATE('2017-10-27 10:03:35','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1942, '查询商品信息', TO_DATE('2017-10-27 10:03:35','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1943, '查询商品类别信息', TO_DATE('2017-10-27 10:03:39','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1944, '添加进货单', TO_DATE('2017-10-27 10:03:51','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (1945, '查询商品信息', TO_DATE('2017-10-27 10:03:52','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1946, '查询商品信息', TO_DATE('2017-10-27 10:03:52','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1947, '查询商品类别信息', TO_DATE('2017-10-27 10:03:53','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1948, '添加进货单', TO_DATE('2017-10-27 10:04:09','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (1949, '查询商品信息', TO_DATE('2017-10-27 10:04:10','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1950, '查询商品信息', TO_DATE('2017-10-27 10:04:10','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1951, '查询商品信息', TO_DATE('2017-10-27 10:06:37','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1952, '查询商品信息', TO_DATE('2017-10-27 10:06:37','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1953, '查询商品信息', TO_DATE('2017-10-27 10:11:11','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1954, '查询商品信息', TO_DATE('2017-10-27 10:11:11','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1955, '查询商品类别信息', TO_DATE('2017-10-27 10:11:12','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1956, '添加退货单', TO_DATE('2017-10-27 10:11:22','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (1957, '查询商品信息', TO_DATE('2017-10-27 10:11:23','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1958, '查询商品信息', TO_DATE('2017-10-27 10:11:23','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1959, '查询商品信息', TO_DATE('2017-10-27 10:14:05','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1960, '查询商品信息', TO_DATE('2017-10-27 10:14:05','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1961, '查询商品类别信息', TO_DATE('2017-10-27 10:14:07','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1962, '添加销售单', TO_DATE('2017-10-27 10:14:59','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (1963, '查询商品信息', TO_DATE('2017-10-27 10:15:01','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1964, '查询商品信息', TO_DATE('2017-10-27 10:15:01','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1965, '查询商品信息', TO_DATE('2017-10-27 10:15:07','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1966, '查询商品信息', TO_DATE('2017-10-27 10:15:07','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1967, '查询商品类别信息', TO_DATE('2017-10-27 10:15:10','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1968, '添加客户退货单', TO_DATE('2017-10-27 10:15:18','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (1969, '查询商品信息', TO_DATE('2017-10-27 10:15:20','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1970, '查询商品信息', TO_DATE('2017-10-27 10:15:20','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1971, '查询商品信息', TO_DATE('2017-10-27 10:15:28','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1972, '查询商品信息', TO_DATE('2017-10-27 10:15:28','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1973, '查询商品信息', TO_DATE('2017-10-27 10:15:34','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1974, '查询商品信息', TO_DATE('2017-10-27 10:15:34','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1975, '查询商品类别信息', TO_DATE('2017-10-27 10:16:55','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1976, '添加报损单', TO_DATE('2017-10-27 10:17:05','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (1977, '查询商品信息', TO_DATE('2017-10-27 10:17:06','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1978, '查询商品信息', TO_DATE('2017-10-27 10:17:06','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1979, '查询商品类别信息', TO_DATE('2017-10-27 10:17:09','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1980, '添加报溢单', TO_DATE('2017-10-27 10:17:20','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (1981, '查询商品信息', TO_DATE('2017-10-27 10:17:21','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1982, '查询商品信息', TO_DATE('2017-10-27 10:17:21','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1983, '用户登录', TO_DATE('2017-10-27 18:55:03','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (1984, '用户注销', TO_DATE('2017-10-27 18:55:31','YYYY-MM-DD HH24:MI:SS'), '注销操作', 1);
INSERT INTO t_log VALUES (1985, '用户登录', TO_DATE('2017-10-27 18:55:35','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (1986, '用户注销', TO_DATE('2017-10-27 18:56:00','YYYY-MM-DD HH24:MI:SS'), '注销操作', 1);
INSERT INTO t_log VALUES (1987, '用户登录', TO_DATE('2017-10-27 18:56:04','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (1988, '用户注销', TO_DATE('2017-10-27 18:56:44','YYYY-MM-DD HH24:MI:SS'), '注销操作', 1);
INSERT INTO t_log VALUES (1989, '用户登录', TO_DATE('2017-10-27 18:56:48','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (1990, '用户登录', TO_DATE('2017-10-27 19:36:59','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (1991, '查询商品信息', TO_DATE('2017-10-27 19:40:14','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1992, '查询商品信息', TO_DATE('2017-10-27 19:40:14','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1993, '查询商品类别信息', TO_DATE('2017-10-27 19:40:15','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1994, '添加报损单', TO_DATE('2017-10-27 19:40:25','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (1995, '查询商品信息', TO_DATE('2017-10-27 19:40:26','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1996, '查询商品信息', TO_DATE('2017-10-27 19:40:26','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1997, '删除进货单信息null', TO_DATE('2017-10-27 19:49:02','YYYY-MM-DD HH24:MI:SS'), '删除操作', 1);
INSERT INTO t_log VALUES (1998, '查询商品信息', TO_DATE('2017-10-27 19:54:18','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (1999, '查询商品信息', TO_DATE('2017-10-27 19:54:18','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2000, '查询商品类别信息', TO_DATE('2017-10-27 19:54:22','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2001, '添加报溢单', TO_DATE('2017-10-27 19:54:28','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2002, '查询商品信息', TO_DATE('2017-10-27 19:54:29','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2003, '查询商品信息', TO_DATE('2017-10-27 19:54:29','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2004, '用户登录', TO_DATE('2017-10-27 20:00:43','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2005, '用户登录', TO_DATE('2017-10-28 10:13:17','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2006, '查询商品信息', TO_DATE('2017-10-28 10:13:38','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2007, '查询商品信息', TO_DATE('2017-10-28 10:13:38','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2008, '查询商品信息', TO_DATE('2017-10-28 10:33:23','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2009, '查询商品信息', TO_DATE('2017-10-28 10:33:23','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2010, '查询商品类别信息', TO_DATE('2017-10-28 10:34:28','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2011, '添加销售单', TO_DATE('2017-10-28 10:34:39','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2012, '查询商品信息', TO_DATE('2017-10-28 10:34:40','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2013, '查询商品信息', TO_DATE('2017-10-28 10:34:40','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2014, '查询商品信息', TO_DATE('2017-10-28 10:41:00','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2015, '查询商品信息', TO_DATE('2017-10-28 10:41:00','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2016, '查询商品类别信息', TO_DATE('2017-10-28 10:41:01','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2017, '添加客户退货单', TO_DATE('2017-10-28 10:41:09','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2018, '查询商品信息', TO_DATE('2017-10-28 10:41:10','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2019, '查询商品信息', TO_DATE('2017-10-28 10:41:10','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2020, '查询供应商信息', TO_DATE('2017-10-28 11:08:08','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2021, '查询供应商信息', TO_DATE('2017-10-28 11:08:08','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2022, '查询客户信息', TO_DATE('2017-10-28 11:08:08','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2023, '查询客户信息', TO_DATE('2017-10-28 11:08:08','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2024, '查询商品类别信息', TO_DATE('2017-10-28 11:08:15','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2025, '查询商品单位信息', TO_DATE('2017-10-28 11:08:15','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2026, '查询商品信息', TO_DATE('2017-10-28 11:08:15','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2027, '查询商品信息', TO_DATE('2017-10-28 11:08:15','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2028, '查询商品类别信息', TO_DATE('2017-10-28 11:08:46','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2029, '查询商品类别信息', TO_DATE('2017-10-28 11:08:54','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2030, '查询商品类别信息', TO_DATE('2017-10-28 11:18:39','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2031, '查询商品信息（无库存）', TO_DATE('2017-10-28 11:18:58','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2032, '查询商品信息（有库存）', TO_DATE('2017-10-28 11:18:58','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2033, '查询商品信息（有库存）', TO_DATE('2017-10-28 11:18:58','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2034, '查询商品信息（无库存）', TO_DATE('2017-10-28 11:18:58','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2035, '用户登录', TO_DATE('2017-10-28 11:32:06','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2036, '查询商品信息（无库存）', TO_DATE('2017-10-28 11:32:26','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2037, '查询商品信息（无库存）', TO_DATE('2017-10-28 11:32:35','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2038, '用户登录', TO_DATE('2017-10-28 12:07:49','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2039, '查询商品库存信息', TO_DATE('2017-10-28 12:07:52','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2040, '查询商品库存信息', TO_DATE('2017-10-28 12:07:56','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2041, '查询商品库存信息', TO_DATE('2017-10-28 12:07:58','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2042, '查询商品库存信息', TO_DATE('2017-10-28 12:08:21','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2043, '查询商品库存信息', TO_DATE('2017-10-28 12:08:23','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2044, '查询商品库存信息', TO_DATE('2017-10-28 12:08:38','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2045, '查询商品库存信息', TO_DATE('2017-10-28 12:08:45','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2046, '查询商品信息', TO_DATE('2017-10-28 12:09:06','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2047, '查询商品信息', TO_DATE('2017-10-28 12:09:06','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2048, '查询商品类别信息', TO_DATE('2017-10-28 12:09:08','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2049, '添加销售单', TO_DATE('2017-10-28 12:09:23','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2050, '查询商品信息', TO_DATE('2017-10-28 12:09:24','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2051, '查询商品信息', TO_DATE('2017-10-28 12:09:24','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2052, '查询商品库存信息', TO_DATE('2017-10-28 12:09:26','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2053, '查询商品库存信息', TO_DATE('2017-10-28 12:09:30','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2054, '查询商品库存信息', TO_DATE('2017-10-28 12:09:34','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2055, '用户登录', TO_DATE('2017-10-28 20:06:03','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2056, '查询商品类别信息', TO_DATE('2017-10-28 20:06:06','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2057, '查询商品信息', TO_DATE('2017-10-28 20:06:06','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2058, '查询商品单位信息', TO_DATE('2017-10-28 20:06:06','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2059, '查询商品信息', TO_DATE('2017-10-28 20:06:06','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2060, '查询商品库存信息', TO_DATE('2017-10-28 20:08:00','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2061, '查询商品类别信息', TO_DATE('2017-10-28 20:08:01','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2062, '查询商品库存信息', TO_DATE('2017-10-28 20:08:29','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2063, '查询商品类别信息', TO_DATE('2017-10-28 20:08:39','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2064, '查询商品库存信息', TO_DATE('2017-10-28 20:08:47','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2065, '查询商品类别信息', TO_DATE('2017-10-28 20:08:48','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2066, '查询商品类别信息', TO_DATE('2017-10-28 20:09:02','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2067, '查询商品类别信息', TO_DATE('2017-10-28 20:09:04','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2068, '查询商品库存信息', TO_DATE('2017-10-28 20:11:06','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2069, '查询商品类别信息', TO_DATE('2017-10-28 20:11:06','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2070, '查询商品库存信息', TO_DATE('2017-10-28 20:11:21','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2071, '查询商品库存信息', TO_DATE('2017-10-28 20:11:30','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2072, '查询商品类别信息', TO_DATE('2017-10-28 20:11:30','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2073, '查询商品库存信息', TO_DATE('2017-10-28 20:11:43','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2074, '查询商品类别信息', TO_DATE('2017-10-28 20:11:44','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2075, '查询商品库存信息', TO_DATE('2017-10-28 20:12:01','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2076, '查询商品类别信息', TO_DATE('2017-10-28 20:12:02','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2077, '查询商品类别信息', TO_DATE('2017-10-28 20:12:11','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2078, '查询商品库存信息', TO_DATE('2017-10-28 20:12:14','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2079, '查询商品类别信息', TO_DATE('2017-10-28 20:12:14','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2080, '查询商品库存信息', TO_DATE('2017-10-28 20:12:26','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2081, '查询商品类别信息', TO_DATE('2017-10-28 20:12:27','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2082, '查询商品库存信息', TO_DATE('2017-10-28 20:12:30','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2083, '查询商品库存信息', TO_DATE('2017-10-28 20:12:31','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2084, '查询商品类别信息', TO_DATE('2017-10-28 20:12:33','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2085, '查询商品库存信息', TO_DATE('2017-10-28 20:14:01','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2086, '查询商品库存信息', TO_DATE('2017-10-28 20:15:34','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2087, '查询商品类别信息', TO_DATE('2017-10-28 20:15:35','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2088, '查询商品类别信息', TO_DATE('2017-10-28 20:15:37','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2089, '查询商品库存信息', TO_DATE('2017-10-28 20:15:39','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2090, '查询商品库存信息', TO_DATE('2017-10-28 20:15:40','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2091, '查询商品库存信息', TO_DATE('2017-10-28 20:15:43','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2092, '查询商品库存信息', TO_DATE('2017-10-28 20:15:44','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2093, '查询商品类别信息', TO_DATE('2017-10-28 20:15:47','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2094, '查询商品库存信息', TO_DATE('2017-10-28 20:15:59','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2095, '查询商品类别信息', TO_DATE('2017-10-28 20:16:00','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2096, '查询商品库存信息', TO_DATE('2017-10-28 20:16:02','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2097, '查询商品类别信息', TO_DATE('2017-10-28 20:16:03','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2098, '查询商品库存信息', TO_DATE('2017-10-28 20:16:05','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2099, '查询商品类别信息', TO_DATE('2017-10-28 20:16:06','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2100, '查询商品库存信息', TO_DATE('2017-10-28 20:16:19','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2101, '查询商品库存信息', TO_DATE('2017-10-28 20:16:24','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2102, '查询商品库存信息', TO_DATE('2017-10-28 20:16:33','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2103, '查询商品库存信息', TO_DATE('2017-10-28 20:16:33','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2104, '查询商品库存信息', TO_DATE('2017-10-28 20:17:07','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2105, '查询商品类别信息', TO_DATE('2017-10-28 20:17:11','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2106, '查询商品库存信息', TO_DATE('2017-10-28 20:17:25','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2107, '用户登录', TO_DATE('2017-10-28 20:20:53','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2108, '查询商品库存信息', TO_DATE('2017-10-28 20:20:56','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2109, '查询商品库存信息', TO_DATE('2017-10-28 20:20:58','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2110, '查询商品库存信息', TO_DATE('2017-10-28 20:21:00','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2111, '查询商品库存信息', TO_DATE('2017-10-28 20:21:02','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2112, '查询商品类别信息', TO_DATE('2017-10-28 20:21:03','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2113, '查询商品库存信息', TO_DATE('2017-10-28 20:21:07','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2114, '查询商品库存信息', TO_DATE('2017-10-28 20:21:27','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2115, '查询商品库存信息', TO_DATE('2017-10-28 20:21:36','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2116, '用户登录', TO_DATE('2017-10-28 20:22:38','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2117, '查询商品库存信息', TO_DATE('2017-10-28 20:22:39','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2118, '查询商品库存信息', TO_DATE('2017-10-28 20:22:42','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2119, '查询商品库存信息', TO_DATE('2017-10-28 20:22:46','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2120, '查询商品库存信息', TO_DATE('2017-10-28 20:27:27','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2121, '查询商品库存信息', TO_DATE('2017-10-28 20:27:32','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2122, '查询商品库存信息', TO_DATE('2017-10-28 20:27:34','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2123, '查询商品库存信息', TO_DATE('2017-10-28 20:27:40','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2124, '查询商品库存信息', TO_DATE('2017-10-28 20:27:41','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2125, '查询商品库存信息', TO_DATE('2017-10-28 20:27:42','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2126, '查询商品库存信息', TO_DATE('2017-10-28 20:27:44','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2127, '查询商品库存信息', TO_DATE('2017-10-28 20:30:49','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2128, '查询商品信息', TO_DATE('2017-10-28 20:31:05','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2129, '查询商品信息', TO_DATE('2017-10-28 20:31:05','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2130, '查询商品类别信息', TO_DATE('2017-10-28 20:31:10','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2131, '查询商品信息', TO_DATE('2017-10-28 20:31:22','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2132, '查询商品信息', TO_DATE('2017-10-28 20:31:22','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2133, '查询商品类别信息', TO_DATE('2017-10-28 20:31:22','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2134, '查询商品类别信息', TO_DATE('2017-10-28 20:31:31','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2135, '添加进货单', TO_DATE('2017-10-28 20:31:38','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2136, '查询商品信息', TO_DATE('2017-10-28 20:31:40','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2137, '查询商品信息', TO_DATE('2017-10-28 20:31:40','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2138, '查询商品库存信息', TO_DATE('2017-10-28 20:31:59','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2139, '查询商品库存信息', TO_DATE('2017-10-28 20:32:00','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2140, '查询商品库存信息', TO_DATE('2017-10-28 20:32:00','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2141, '用户登录', TO_DATE('2017-10-29 08:55:04','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2142, '查询商品库存信息', TO_DATE('2017-10-29 08:55:04','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2143, '查询商品库存信息', TO_DATE('2017-10-29 08:55:07','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2144, '查询商品库存信息', TO_DATE('2017-10-29 08:55:33','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2145, '用户登录', TO_DATE('2017-10-29 09:35:36','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2146, '查询商品库存信息', TO_DATE('2017-10-29 09:35:36','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2147, '查询商品库存信息', TO_DATE('2017-10-29 09:35:38','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2148, '查询商品信息', TO_DATE('2017-10-29 09:35:41','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2149, '查询商品信息', TO_DATE('2017-10-29 09:35:41','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2150, '查询商品信息', TO_DATE('2017-10-29 09:35:41','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2151, '查询商品信息', TO_DATE('2017-10-29 09:35:41','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2152, '用户登录', TO_DATE('2017-10-29 16:12:34','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2153, '查询商品库存信息', TO_DATE('2017-10-29 16:12:35','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2154, '查询商品库存信息', TO_DATE('2017-10-29 16:16:19','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2155, '查询客户信息', TO_DATE('2017-10-29 16:16:20','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2156, '查询客户信息', TO_DATE('2017-10-29 16:16:20','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2157, '查询商品类别信息', TO_DATE('2017-10-29 16:16:21','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2158, '查询商品单位信息', TO_DATE('2017-10-29 16:16:21','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2159, '查询商品信息', TO_DATE('2017-10-29 16:16:21','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2160, '查询商品信息', TO_DATE('2017-10-29 16:16:21','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2161, '查询商品信息（无库存）', TO_DATE('2017-10-29 16:16:22','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2162, '查询商品信息（有库存）', TO_DATE('2017-10-29 16:16:22','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2163, '查询商品信息（有库存）', TO_DATE('2017-10-29 16:16:22','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2164, '查询商品信息（无库存）', TO_DATE('2017-10-29 16:16:22','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2165, '查询供应商信息', TO_DATE('2017-10-29 16:16:23','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2166, '查询供应商信息', TO_DATE('2017-10-29 16:16:23','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2167, '查询角色信息', TO_DATE('2017-10-29 16:16:25','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2168, '查询角色信息', TO_DATE('2017-10-29 16:16:25','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2169, '查询用户信息', TO_DATE('2017-10-29 16:16:26','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2170, '查询用户信息', TO_DATE('2017-10-29 16:16:26','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2171, '查询商品信息', TO_DATE('2017-10-29 16:16:33','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2172, '查询商品信息', TO_DATE('2017-10-29 16:16:33','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2173, '查询商品信息', TO_DATE('2017-10-29 16:16:35','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2174, '查询商品信息', TO_DATE('2017-10-29 16:16:35','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2175, '用户登录', TO_DATE('2017-10-29 16:52:51','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2176, '查询商品库存信息', TO_DATE('2017-10-29 16:52:51','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2177, '查询供应商信息', TO_DATE('2017-10-29 16:52:54','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2178, '查询供应商信息', TO_DATE('2017-10-29 16:52:54','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2179, '用户注销', TO_DATE('2017-10-29 17:10:28','YYYY-MM-DD HH24:MI:SS'), '注销操作', 1);
INSERT INTO t_log VALUES (2180, '用户登录', TO_DATE('2017-10-29 17:10:56','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2181, '查询商品库存信息', TO_DATE('2017-10-29 17:10:56','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2182, '查询角色信息', TO_DATE('2017-10-29 17:11:03','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2183, '查询角色信息', TO_DATE('2017-10-29 17:11:03','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2184, '查询用户信息', TO_DATE('2017-10-29 17:11:15','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2185, '查询用户信息', TO_DATE('2017-10-29 17:11:15','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2186, '查询所有角色信息', TO_DATE('2017-10-29 17:11:16','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2187, '查询商品信息（无库存）', TO_DATE('2017-10-29 17:11:29','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2188, '查询商品信息（无库存）', TO_DATE('2017-10-29 17:11:29','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2189, '查询商品信息（有库存）', TO_DATE('2017-10-29 17:11:29','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2190, '查询商品信息（有库存）', TO_DATE('2017-10-29 17:11:29','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2191, '查询商品类别信息', TO_DATE('2017-10-29 17:11:33','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2192, '查询商品信息', TO_DATE('2017-10-29 17:11:33','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2193, '查询商品单位信息', TO_DATE('2017-10-29 17:11:33','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2194, '查询商品信息', TO_DATE('2017-10-29 17:11:33','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2195, '查询商品类别信息', TO_DATE('2017-10-29 17:11:40','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2196, '用户登录', TO_DATE('2017-10-29 17:42:10','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2197, '查询商品库存信息', TO_DATE('2017-10-29 17:42:10','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2198, '用户登录', TO_DATE('2017-10-29 19:40:13','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2199, '查询商品库存信息', TO_DATE('2017-10-29 19:40:14','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2200, '查询商品信息', TO_DATE('2017-10-29 19:48:19','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2201, '查询商品信息', TO_DATE('2017-10-29 19:48:19','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2202, '查询商品类别信息', TO_DATE('2017-10-29 19:48:20','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2203, '添加进货单', TO_DATE('2017-10-29 19:48:37','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2204, '查询商品信息', TO_DATE('2017-10-29 19:48:38','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2205, '查询商品信息', TO_DATE('2017-10-29 19:48:38','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2206, '查询商品库存信息', TO_DATE('2017-10-29 20:24:31','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2207, '查询商品库存信息', TO_DATE('2017-10-29 20:24:33','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2208, '用户登录', TO_DATE('2017-10-29 20:24:56','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2209, '查询商品库存信息', TO_DATE('2017-10-29 20:24:56','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2210, '用户登录', TO_DATE('2017-10-29 20:33:48','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2211, '查询商品库存信息', TO_DATE('2017-10-29 20:33:48','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2212, '查询商品库存信息', TO_DATE('2017-10-29 20:34:36','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2213, '用户注销', TO_DATE('2017-10-29 20:34:39','YYYY-MM-DD HH24:MI:SS'), '注销操作', 1);
INSERT INTO t_log VALUES (2214, '用户登录', TO_DATE('2017-10-29 20:34:44','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2215, '查询商品库存信息', TO_DATE('2017-10-29 20:34:44','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2216, '查询商品类别信息', TO_DATE('2017-10-29 20:34:56','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2217, '用户登录', TO_DATE('2017-10-30 09:35:23','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2218, '查询商品库存信息', TO_DATE('2017-10-30 09:35:23','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2219, '查询商品信息', TO_DATE('2017-10-30 09:35:26','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2220, '查询商品信息', TO_DATE('2017-10-30 09:35:26','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2221, '查询商品信息', TO_DATE('2017-10-30 09:35:27','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2222, '查询商品信息', TO_DATE('2017-10-30 09:35:27','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2223, '查询供应商信息', TO_DATE('2017-10-30 09:41:15','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2224, '查询供应商信息', TO_DATE('2017-10-30 09:41:15','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2225, '查询客户信息', TO_DATE('2017-10-30 09:42:13','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2226, '查询客户信息', TO_DATE('2017-10-30 09:42:13','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2227, '查询商品信息', TO_DATE('2017-10-30 09:42:28','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2228, '查询商品信息', TO_DATE('2017-10-30 09:42:28','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2229, '查询商品库存信息', TO_DATE('2017-10-30 09:43:06','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2230, '用户登录', TO_DATE('2017-10-30 10:47:44','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2231, '查询商品库存信息', TO_DATE('2017-10-30 10:47:45','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2232, '查询商品信息', TO_DATE('2017-10-30 10:47:56','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2233, '查询商品信息', TO_DATE('2017-10-30 10:47:56','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2234, '查询商品信息', TO_DATE('2017-10-30 10:48:04','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2235, '查询商品信息', TO_DATE('2017-10-30 10:48:04','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2236, '查询商品类别信息', TO_DATE('2017-10-30 10:48:12','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2237, '查询商品库存信息', TO_DATE('2017-10-30 11:04:51','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2238, '查询商品信息', TO_DATE('2017-10-30 11:04:54','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2239, '查询商品信息', TO_DATE('2017-10-30 11:04:54','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2240, '查询商品信息', TO_DATE('2017-10-30 11:05:17','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2241, '查询商品信息', TO_DATE('2017-10-30 11:05:17','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2242, '查询商品类别信息', TO_DATE('2017-10-30 11:05:21','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2243, '添加销售单', TO_DATE('2017-10-30 11:05:25','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2244, '查询商品信息', TO_DATE('2017-10-30 11:05:27','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2245, '查询商品信息', TO_DATE('2017-10-30 11:05:27','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2246, '查询商品信息', TO_DATE('2017-10-30 11:05:51','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2247, '查询商品信息', TO_DATE('2017-10-30 11:05:51','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2248, '查询商品信息', TO_DATE('2017-10-30 11:08:58','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2249, '查询商品信息', TO_DATE('2017-10-30 11:08:58','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2250, '查询商品类别信息', TO_DATE('2017-10-30 11:09:08','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2251, '添加客户退货单', TO_DATE('2017-10-30 11:09:12','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2252, '查询商品信息', TO_DATE('2017-10-30 11:09:13','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2253, '查询商品信息', TO_DATE('2017-10-30 11:09:13','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2254, '用户登录', TO_DATE('2017-10-30 12:06:06','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2255, '查询商品库存信息', TO_DATE('2017-10-30 12:06:07','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2256, '查询商品库存信息', TO_DATE('2017-10-30 12:15:05','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2257, '用户登录', TO_DATE('2017-10-30 12:15:23','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2258, '查询商品库存信息', TO_DATE('2017-10-30 12:15:24','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2259, '用户登录', TO_DATE('2017-10-30 12:16:19','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2260, '查询商品库存信息', TO_DATE('2017-10-30 12:16:19','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2261, '用户登录', TO_DATE('2017-10-30 12:31:48','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2262, '查询商品库存信息', TO_DATE('2017-10-30 12:31:49','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2263, '查询商品信息', TO_DATE('2017-10-30 12:33:08','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2264, '查询商品信息', TO_DATE('2017-10-30 12:33:08','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2265, '查询商品类别信息', TO_DATE('2017-10-30 12:33:12','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2266, '查询商品信息', TO_DATE('2017-10-30 12:33:17','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2267, '添加销售单', TO_DATE('2017-10-30 12:33:24','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2268, '查询商品信息', TO_DATE('2017-10-30 12:33:26','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2269, '查询商品信息', TO_DATE('2017-10-30 12:33:26','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2270, '查询商品信息', TO_DATE('2017-10-30 12:33:53','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2271, '查询商品信息', TO_DATE('2017-10-30 12:33:53','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2272, '查询商品类别信息', TO_DATE('2017-10-30 12:34:01','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2273, '添加客户退货单', TO_DATE('2017-10-30 12:34:17','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2274, '查询商品信息', TO_DATE('2017-10-30 12:34:19','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2275, '查询商品信息', TO_DATE('2017-10-30 12:34:19','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2276, '用户登录', TO_DATE('2017-10-30 18:20:23','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2277, '查询商品库存信息', TO_DATE('2017-10-30 18:20:23','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2278, '用户登录', TO_DATE('2017-10-31 10:49:39','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2279, '查询商品库存信息', TO_DATE('2017-10-31 10:49:40','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2280, '用户注销', TO_DATE('2017-10-31 10:50:19','YYYY-MM-DD HH24:MI:SS'), '注销操作', 1);
INSERT INTO t_log VALUES (2281, '用户登录', TO_DATE('2017-10-31 10:50:23','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2282, '查询商品库存信息', TO_DATE('2017-10-31 10:50:23','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2283, '查询商品类别信息', TO_DATE('2017-10-31 11:02:29','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2284, '查询商品信息', TO_DATE('2017-10-31 11:04:10','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2285, '查询商品信息', TO_DATE('2017-10-31 11:04:10','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2286, '查询商品库存信息', TO_DATE('2017-10-31 11:04:12','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2287, '查询商品类别信息', TO_DATE('2017-10-31 11:07:16','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2288, '用户注销', TO_DATE('2017-10-31 11:20:24','YYYY-MM-DD HH24:MI:SS'), '注销操作', 1);
INSERT INTO t_log VALUES (2289, '用户登录', TO_DATE('2017-10-31 11:21:19','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2290, '查询商品库存信息', TO_DATE('2017-10-31 11:21:20','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2291, '查询商品信息', TO_DATE('2017-10-31 11:22:11','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2292, '查询商品信息', TO_DATE('2017-10-31 11:22:11','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2293, '查询角色信息', TO_DATE('2017-10-31 11:22:14','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2294, '查询角色信息', TO_DATE('2017-10-31 11:22:14','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2295, '查询用户信息', TO_DATE('2017-10-31 11:22:21','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2296, '查询用户信息', TO_DATE('2017-10-31 11:22:21','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2297, '查询所有角色信息', TO_DATE('2017-10-31 11:22:22','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2298, '查询商品类别信息', TO_DATE('2017-10-31 11:22:45','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2299, '查询商品类别信息', TO_DATE('2017-10-31 11:22:55','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2300, '查询供应商信息', TO_DATE('2017-10-31 11:23:06','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2301, '查询供应商信息', TO_DATE('2017-10-31 11:23:06','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2302, '查询客户信息', TO_DATE('2017-10-31 11:23:07','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2303, '查询客户信息', TO_DATE('2017-10-31 11:23:07','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2304, '查询商品类别信息', TO_DATE('2017-10-31 11:23:10','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2305, '查询商品单位信息', TO_DATE('2017-10-31 11:23:10','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2306, '查询商品信息', TO_DATE('2017-10-31 11:23:10','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2307, '查询商品信息', TO_DATE('2017-10-31 11:23:10','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2308, '查询商品类别信息', TO_DATE('2017-10-31 11:23:13','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2309, '查询商品库存信息', TO_DATE('2017-10-31 11:37:13','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2310, '用户登录', TO_DATE('2017-10-31 12:10:54','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2311, '查询商品库存信息', TO_DATE('2017-10-31 12:10:54','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2312, '查询商品库存信息', TO_DATE('2017-10-31 12:13:32','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2313, '用户登录', TO_DATE('2017-10-31 12:21:21','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2314, '查询商品库存信息', TO_DATE('2017-10-31 12:21:22','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2315, '用户登录', TO_DATE('2017-10-31 16:28:16','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2316, '查询商品库存信息', TO_DATE('2017-10-31 16:28:16','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2317, '用户登录', TO_DATE('2017-10-31 16:50:55','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2318, '查询商品库存信息', TO_DATE('2017-10-31 16:50:56','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2319, '用户登录', TO_DATE('2017-10-31 16:55:11','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2320, '查询商品库存信息', TO_DATE('2017-10-31 16:55:12','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2321, '用户登录', TO_DATE('2017-10-31 17:06:04','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2322, '查询商品库存信息', TO_DATE('2017-10-31 17:06:05','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2323, '用户登录', TO_DATE('2017-10-31 17:06:36','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2324, '查询商品库存信息', TO_DATE('2017-10-31 17:06:37','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2325, '用户登录', TO_DATE('2017-10-31 17:13:40','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2326, '查询商品库存信息', TO_DATE('2017-10-31 17:13:41','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2327, '查询商品信息', TO_DATE('2017-10-31 17:13:52','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2328, '查询商品信息', TO_DATE('2017-10-31 17:13:52','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2329, '查询商品信息', TO_DATE('2017-10-31 17:13:59','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2330, '查询商品信息', TO_DATE('2017-10-31 17:13:59','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2331, '查询商品类别信息', TO_DATE('2017-10-31 17:14:00','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2332, '添加进货单', TO_DATE('2017-10-31 17:14:12','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2333, '查询商品信息', TO_DATE('2017-10-31 17:14:14','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2334, '查询商品信息', TO_DATE('2017-10-31 17:14:14','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2335, '用户登录', TO_DATE('2017-10-31 17:24:29','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2336, '查询商品库存信息', TO_DATE('2017-10-31 17:24:30','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2337, '用户登录', TO_DATE('2017-10-31 17:27:32','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2338, '查询商品库存信息', TO_DATE('2017-10-31 17:27:32','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2339, '用户登录', TO_DATE('2017-10-31 17:31:43','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2340, '查询商品库存信息', TO_DATE('2017-10-31 17:31:44','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2341, '查询商品类别信息', TO_DATE('2017-10-31 17:44:53','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2342, '用户登录', TO_DATE('2017-10-31 18:19:21','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2343, '查询商品库存信息', TO_DATE('2017-10-31 18:19:21','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2344, '用户登录', TO_DATE('2017-10-31 18:23:15','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2345, '查询商品库存信息', TO_DATE('2017-10-31 18:23:16','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2346, '用户登录', TO_DATE('2017-10-31 18:42:43','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2347, '查询商品库存信息', TO_DATE('2017-10-31 18:42:44','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2348, '用户登录', TO_DATE('2017-10-31 20:04:44','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2349, '查询商品库存信息', TO_DATE('2017-10-31 20:04:45','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2350, '用户登录', TO_DATE('2017-10-31 20:07:13','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2351, '查询商品库存信息', TO_DATE('2017-10-31 20:07:14','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2352, '用户登录', TO_DATE('2017-10-31 20:08:07','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2353, '查询商品库存信息', TO_DATE('2017-10-31 20:08:07','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2354, '用户登录', TO_DATE('2017-10-31 20:12:51','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2355, '查询商品库存信息', TO_DATE('2017-10-31 20:12:52','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2356, '查询商品库存信息', TO_DATE('2017-10-31 20:13:39','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2357, '查询商品库存信息', TO_DATE('2017-10-31 20:17:50','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2358, '查询商品类别信息', TO_DATE('2017-10-31 20:26:50','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2359, '查询商品类别信息', TO_DATE('2017-10-31 20:26:59','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2360, '查询商品类别信息', TO_DATE('2017-10-31 20:28:35','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2361, '查询商品类别信息', TO_DATE('2017-10-31 20:28:39','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2362, '用户登录', TO_DATE('2017-11-01 17:38:14','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2363, '查询商品库存信息', TO_DATE('2017-11-01 17:38:15','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2364, '用户登录', TO_DATE('2017-11-01 18:21:17','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2365, '查询商品库存信息', TO_DATE('2017-11-01 18:21:17','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2366, '查询商品信息', TO_DATE('2017-11-01 18:26:37','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2367, '查询商品信息', TO_DATE('2017-11-01 18:26:37','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2368, '查询商品类别信息', TO_DATE('2017-11-01 18:26:40','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2369, '添加销售单', TO_DATE('2017-11-01 18:28:03','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2370, '查询商品信息', TO_DATE('2017-11-01 18:28:04','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2371, '查询商品信息', TO_DATE('2017-11-01 18:28:04','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2372, '查询商品类别信息', TO_DATE('2017-11-01 18:30:24','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2373, '查询商品类别信息', TO_DATE('2017-11-01 18:30:32','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2374, '添加销售单', TO_DATE('2017-11-01 18:30:53','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2375, '查询商品信息', TO_DATE('2017-11-01 18:30:54','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2376, '查询商品信息', TO_DATE('2017-11-01 18:30:54','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2377, '查询商品类别信息', TO_DATE('2017-11-01 18:33:10','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2378, '查询商品类别信息', TO_DATE('2017-11-01 18:33:17','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2379, '添加销售单', TO_DATE('2017-11-01 18:33:28','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2380, '查询商品信息', TO_DATE('2017-11-01 18:33:30','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2381, '查询商品信息', TO_DATE('2017-11-01 18:33:30','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2382, '用户登录', TO_DATE('2017-11-01 20:01:18','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2383, '查询商品库存信息', TO_DATE('2017-11-01 20:01:18','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2384, '用户登录', TO_DATE('2017-11-01 20:02:43','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2385, '查询商品库存信息', TO_DATE('2017-11-01 20:02:44','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2386, '用户登录', TO_DATE('2017-11-01 20:11:52','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2387, '查询商品库存信息', TO_DATE('2017-11-01 20:11:52','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2388, '用户登录', TO_DATE('2017-11-01 20:13:32','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2389, '查询商品库存信息', TO_DATE('2017-11-01 20:13:32','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2390, '用户登录', TO_DATE('2017-11-01 20:19:35','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2391, '查询商品库存信息', TO_DATE('2017-11-01 20:19:35','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2392, '用户登录', TO_DATE('2017-11-01 20:20:35','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2393, '查询商品库存信息', TO_DATE('2017-11-01 20:20:36','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2394, '用户登录', TO_DATE('2017-11-01 20:22:19','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2395, '查询商品库存信息', TO_DATE('2017-11-01 20:22:19','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2396, '用户登录', TO_DATE('2017-11-01 20:23:31','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2397, '查询商品库存信息', TO_DATE('2017-11-01 20:23:32','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2398, '用户登录', TO_DATE('2017-11-01 20:24:04','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2399, '查询商品库存信息', TO_DATE('2017-11-01 20:24:05','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2400, '用户登录', TO_DATE('2017-11-01 20:25:38','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2401, '查询商品库存信息', TO_DATE('2017-11-01 20:25:38','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2402, '用户登录', TO_DATE('2017-11-01 20:28:01','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2403, '查询商品库存信息', TO_DATE('2017-11-01 20:28:02','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2404, '用户登录', TO_DATE('2017-11-01 20:35:00','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2405, '查询商品库存信息', TO_DATE('2017-11-01 20:35:01','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2406, '用户登录', TO_DATE('2017-11-01 20:35:55','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2407, '查询商品库存信息', TO_DATE('2017-11-01 20:35:55','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2408, '用户登录', TO_DATE('2017-11-02 10:10:14','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2409, '查询商品库存信息', TO_DATE('2017-11-02 10:10:15','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2410, '用户登录', TO_DATE('2017-11-02 14:31:46','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2411, '查询商品库存信息', TO_DATE('2017-11-02 14:31:47','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2412, '查询商品信息', TO_DATE('2017-11-02 14:31:57','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2413, '查询商品信息', TO_DATE('2017-11-02 14:31:57','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2414, '查询商品信息', TO_DATE('2017-11-02 14:31:58','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2415, '查询商品信息', TO_DATE('2017-11-02 14:31:58','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2416, '查询商品信息', TO_DATE('2017-11-02 14:32:31','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2417, '查询商品信息', TO_DATE('2017-11-02 14:32:31','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2418, '用户登录', TO_DATE('2017-11-02 18:17:40','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2419, '查询商品库存信息', TO_DATE('2017-11-02 18:17:41','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2420, '查询商品信息', TO_DATE('2017-11-02 18:28:44','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2421, '查询商品信息', TO_DATE('2017-11-02 18:28:44','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2422, '用户登录', TO_DATE('2017-11-02 19:01:25','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2423, '查询商品库存信息', TO_DATE('2017-11-02 19:01:25','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2424, '用户登录', TO_DATE('2017-11-02 19:03:17','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2425, '查询商品库存信息', TO_DATE('2017-11-02 19:03:18','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2426, '查询商品信息', TO_DATE('2017-11-02 19:03:21','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2427, '查询商品信息', TO_DATE('2017-11-02 19:03:21','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2428, '查询商品库存信息', TO_DATE('2017-11-02 20:17:58','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2429, '查询商品库存信息', TO_DATE('2017-11-02 20:18:22','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2430, '查询商品库存信息', TO_DATE('2017-11-02 20:18:23','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2431, '查询商品库存信息', TO_DATE('2017-11-02 20:20:06','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2432, '用户登录', TO_DATE('2017-11-03 09:12:17','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2433, '查询商品库存信息', TO_DATE('2017-11-03 09:12:18','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2434, '用户登录', TO_DATE('2017-11-03 09:33:36','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2435, '查询商品库存信息', TO_DATE('2017-11-03 09:33:37','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2436, '查询商品库存信息', TO_DATE('2017-11-03 09:36:05','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2437, '查询商品库存信息', TO_DATE('2017-11-03 09:36:06','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2438, '查询商品库存信息', TO_DATE('2017-11-03 09:36:15','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2439, '查询商品库存信息', TO_DATE('2017-11-03 09:36:17','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2440, '查询商品库存信息', TO_DATE('2017-11-03 10:10:08','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2441, '查询商品库存信息', TO_DATE('2017-11-03 10:10:08','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2442, '查询商品库存信息', TO_DATE('2017-11-03 10:10:09','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2443, '查询商品库存信息', TO_DATE('2017-11-03 10:23:04','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2444, '用户登录', TO_DATE('2017-11-03 11:17:35','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2445, '查询商品库存信息', TO_DATE('2017-11-03 11:17:35','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2446, '用户登录', TO_DATE('2017-11-03 11:19:20','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2447, '查询商品库存信息', TO_DATE('2017-11-03 11:19:21','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2448, '查询商品库存信息', TO_DATE('2017-11-03 11:20:39','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2449, '用户登录', TO_DATE('2017-11-03 15:18:40','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2450, '查询商品库存信息', TO_DATE('2017-11-03 15:18:40','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2451, '查询商品库存信息', TO_DATE('2017-11-03 15:32:43','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2452, '查询商品库存信息', TO_DATE('2017-11-03 15:32:46','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2453, '查询商品库存信息', TO_DATE('2017-11-03 15:32:48','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2454, '用户登录', TO_DATE('2017-11-03 18:50:34','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2455, '查询商品库存信息', TO_DATE('2017-11-03 18:50:35','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2456, '用户登录', TO_DATE('2017-11-03 18:51:23','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2457, '查询商品库存信息', TO_DATE('2017-11-03 18:51:23','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2458, '查询商品信息', TO_DATE('2017-11-03 18:57:55','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2459, '查询商品信息', TO_DATE('2017-11-03 18:57:55','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2460, '查询商品库存信息', TO_DATE('2017-11-03 18:57:58','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2461, '查询商品类别信息', TO_DATE('2017-11-03 19:02:08','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2462, '查询供应商信息', TO_DATE('2017-11-03 19:03:33','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2463, '查询供应商信息', TO_DATE('2017-11-03 19:03:33','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2464, '添加供应商信息[id=null, name=南京大王科技, contact=小二, number=0112-1426789, address=南京鼓楼区世纪大楼123号, remarks=]', TO_DATE('2017-11-03 19:04:30','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2465, '查询供应商信息', TO_DATE('2017-11-03 19:04:30','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2466, '查询供应商信息', TO_DATE('2017-11-03 19:04:32','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2467, '更新供应商信息[id=12, name=南京大王科技, contact=小二, number=0112-1426789, address=南京鼓楼区世纪大楼123号, remarks=123]', TO_DATE('2017-11-03 19:04:40','YYYY-MM-DD HH24:MI:SS'), '更新操作', 1);
INSERT INTO t_log VALUES (2468, '查询供应商信息', TO_DATE('2017-11-03 19:04:40','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2469, '查询供应商信息', TO_DATE('2017-11-03 19:04:43','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2470, '查询供应商信息', TO_DATE('2017-11-03 19:04:44','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2471, '添加供应商信息[id=null, name=南京大陆食品公司, contact=小吴, number=1243-2135487, address=南京将军路800号, remarks=cc]', TO_DATE('2017-11-03 19:13:43','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2472, '查询供应商信息', TO_DATE('2017-11-03 19:13:43','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2473, '添加供应商信息[id=null, name=ew, contact=ewq, number=ewq, address=ewq, remarks=ewq]', TO_DATE('2017-11-03 19:14:47','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2474, '查询供应商信息', TO_DATE('2017-11-03 19:14:47','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2475, '删除供应商信息[id=14, name=ew, contact=ewq, number=ewq, address=ewq, remarks=ewq]', TO_DATE('2017-11-03 19:14:53','YYYY-MM-DD HH24:MI:SS'), '删除操作', 1);
INSERT INTO t_log VALUES (2476, '查询供应商信息', TO_DATE('2017-11-03 19:14:53','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2477, '查询供应商信息', TO_DATE('2017-11-03 19:14:59','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2478, '查询客户信息', TO_DATE('2017-11-03 19:15:02','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2479, '查询客户信息', TO_DATE('2017-11-03 19:15:02','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2480, '添加客户信息[id=null, name=21, contact=321, number=312, address=321, remarks=23]', TO_DATE('2017-11-03 19:19:34','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2481, '查询客户信息', TO_DATE('2017-11-03 19:19:34','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2482, '更新客户信息[id=5, name=21, contact=321, number=312, address=321, remarks=232]', TO_DATE('2017-11-03 19:19:38','YYYY-MM-DD HH24:MI:SS'), '更新操作', 1);
INSERT INTO t_log VALUES (2483, '查询客户信息', TO_DATE('2017-11-03 19:19:39','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2484, '更新客户信息[id=5, name=212, contact=3212, number=3122, address=3212, remarks=2322]', TO_DATE('2017-11-03 19:19:45','YYYY-MM-DD HH24:MI:SS'), '更新操作', 1);
INSERT INTO t_log VALUES (2485, '查询客户信息', TO_DATE('2017-11-03 19:19:45','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2486, '删除客户信息[id=5, name=212, contact=3212, number=3122, address=3212, remarks=2322]', TO_DATE('2017-11-03 19:19:47','YYYY-MM-DD HH24:MI:SS'), '删除操作', 1);
INSERT INTO t_log VALUES (2487, '查询客户信息', TO_DATE('2017-11-03 19:19:47','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2488, '查询客户信息', TO_DATE('2017-11-03 19:19:53','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2489, '查询商品类别信息', TO_DATE('2017-11-03 19:22:25','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2490, '查询商品信息', TO_DATE('2017-11-03 19:22:25','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2491, '查询商品单位信息', TO_DATE('2017-11-03 19:22:25','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2492, '查询商品信息', TO_DATE('2017-11-03 19:22:25','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2493, '查询商品信息', TO_DATE('2017-11-03 19:22:26','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2494, '查询商品信息', TO_DATE('2017-11-03 19:22:27','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2495, '查询商品信息', TO_DATE('2017-11-03 19:22:27','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2496, '查询商品信息', TO_DATE('2017-11-03 19:22:28','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2497, '查询商品信息', TO_DATE('2017-11-03 19:22:28','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2498, '查询商品信息', TO_DATE('2017-11-03 19:22:29','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2499, '查询商品信息', TO_DATE('2017-11-03 19:22:30','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2500, '查询商品信息', TO_DATE('2017-11-03 19:22:30','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);

INSERT INTO t_log VALUES (2501, '查询商品信息', TO_DATE('2017-11-03 19:22:32','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2502, '查询商品信息', TO_DATE('2017-11-03 19:22:33','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2503, '查询商品信息', TO_DATE('2017-11-03 19:22:34','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2504, '查询商品信息', TO_DATE('2017-11-03 19:22:35','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2505, '查询商品信息', TO_DATE('2017-11-03 19:22:35','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2506, '查询商品信息', TO_DATE('2017-11-03 19:22:36','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2507, '查询商品信息', TO_DATE('2017-11-03 19:22:37','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2508, '查询商品信息', TO_DATE('2017-11-03 19:22:37','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2509, '查询商品信息', TO_DATE('2017-11-03 19:22:37','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2510, '查询商品信息', TO_DATE('2017-11-03 19:22:38','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2511, '查询商品信息', TO_DATE('2017-11-03 19:22:44','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2512, '添加商品类别信息[id=null, name=xx, state=0, icon=icon-folder, pId=1]', TO_DATE('2017-11-03 19:22:51','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2513, '查询商品类别信息', TO_DATE('2017-11-03 19:22:51','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2514, '查询商品信息', TO_DATE('2017-11-03 19:22:54','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2515, '添加商品类别信息[id=null, name=22, state=0, icon=icon-folder, pId=18]', TO_DATE('2017-11-03 19:22:58','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2516, '查询商品类别信息', TO_DATE('2017-11-03 19:22:58','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2517, '查询商品信息', TO_DATE('2017-11-03 19:23:00','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2518, '查询商品信息', TO_DATE('2017-11-03 19:23:01','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2519, '删除商品类别信息[id=19, name=22, state=0, icon=icon-folder, pId=18]', TO_DATE('2017-11-03 19:23:02','YYYY-MM-DD HH24:MI:SS'), '删除操作', 1);
INSERT INTO t_log VALUES (2520, '查询商品类别信息', TO_DATE('2017-11-03 19:23:02','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2521, '查询商品信息', TO_DATE('2017-11-03 19:23:03','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2522, '删除商品类别信息[id=18, name=xx, state=0, icon=icon-folder, pId=1]', TO_DATE('2017-11-03 19:23:04','YYYY-MM-DD HH24:MI:SS'), '删除操作', 1);
INSERT INTO t_log VALUES (2523, '查询商品类别信息', TO_DATE('2017-11-03 19:23:04','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2524, '查询商品信息', TO_DATE('2017-11-03 19:23:34','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2525, '查询商品信息', TO_DATE('2017-11-03 19:23:34','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2526, '查询商品信息', TO_DATE('2017-11-03 19:23:35','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2527, '查询商品信息', TO_DATE('2017-11-03 19:23:35','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2528, '查询商品信息', TO_DATE('2017-11-03 19:23:36','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2529, '查询商品信息', TO_DATE('2017-11-03 19:23:41','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2530, '查询商品信息', TO_DATE('2017-11-03 19:23:43','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2531, '查询商品类别信息', TO_DATE('2017-11-03 19:23:51','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2532, '添加商品单位信息[id=null, name=2]', TO_DATE('2017-11-03 19:25:11','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2533, '查询商品单位信息', TO_DATE('2017-11-03 19:25:11','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2534, '查询商品类别信息', TO_DATE('2017-11-03 19:25:18','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2535, '删除商品单位信息[id=10, name=2]', TO_DATE('2017-11-03 19:25:26','YYYY-MM-DD HH24:MI:SS'), '删除操作', 1);
INSERT INTO t_log VALUES (2536, '查询商品单位信息', TO_DATE('2017-11-03 19:25:26','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2537, '添加商品信息[id=null, code=0015, name=xx, model=fds, unit=盒, purchasingPrice=50.0, sellingPrice=100.0, inventoryQuantity=0, minNum=20, producer=21, remarks=321]', TO_DATE('2017-11-03 19:25:36','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2538, '查询商品信息', TO_DATE('2017-11-03 19:25:36','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2539, '查询商品信息', TO_DATE('2017-11-03 19:25:40','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2540, '更新商品信息[id=23, code=0015, name=xx22, model=fds2, unit=盒, purchasingPrice=50.0, sellingPrice=100.0, inventoryQuantity=0, minNum=20, producer=21, remarks=3211]', TO_DATE('2017-11-03 19:35:31','YYYY-MM-DD HH24:MI:SS'), '更新操作', 1);
INSERT INTO t_log VALUES (2541, '查询商品信息', TO_DATE('2017-11-03 19:35:31','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2542, '删除商品信息[id=23, code=0015, name=xx22, model=fds2, unit=盒, purchasingPrice=50.0, sellingPrice=100.0, inventoryQuantity=0, minNum=20, producer=21, remarks=3211]', TO_DATE('2017-11-03 19:35:40','YYYY-MM-DD HH24:MI:SS'), '删除操作', 1);
INSERT INTO t_log VALUES (2543, '查询商品信息', TO_DATE('2017-11-03 19:35:40','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2544, '查询商品信息', TO_DATE('2017-11-03 19:35:50','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2545, '查询商品信息', TO_DATE('2017-11-03 19:35:52','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2546, '查询商品信息', TO_DATE('2017-11-03 19:35:54','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2547, '查询商品信息', TO_DATE('2017-11-03 19:35:56','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2548, '查询商品信息', TO_DATE('2017-11-03 19:35:58','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2549, '查询商品信息（无库存）', TO_DATE('2017-11-03 19:36:02','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2550, '查询商品信息（无库存）', TO_DATE('2017-11-03 19:36:02','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2551, '查询商品信息（有库存）', TO_DATE('2017-11-03 19:36:02','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2552, '查询商品信息（有库存）', TO_DATE('2017-11-03 19:36:02','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2553, '查询商品信息（无库存）', TO_DATE('2017-11-03 19:36:05','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2554, '查询商品信息（无库存）', TO_DATE('2017-11-03 19:36:06','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2555, '查询商品类别信息', TO_DATE('2017-11-03 19:37:53','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2556, '查询商品类别信息', TO_DATE('2017-11-03 19:40:02','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2557, '添加商品信息[id=null, code=0015, name= iPhone X, model=X, unit=台, purchasingPrice=8000.0, sellingPrice=9500.0, inventoryQuantity=0, minNum=100, producer=xx, remarks=xxx]', TO_DATE('2017-11-03 19:40:22','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2558, '查询商品信息', TO_DATE('2017-11-03 19:40:22','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2559, '查询商品信息', TO_DATE('2017-11-03 19:40:24','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2560, '查询商品信息', TO_DATE('2017-11-03 19:40:25','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2561, '查询商品信息', TO_DATE('2017-11-03 19:40:29','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2562, '更新商品信息[id=24, code=0015, name= iPhone X, model=X, unit=台, purchasingPrice=8000.0, sellingPrice=9500.0, inventoryQuantity=0, minNum=100, producer=xx2, remarks=xxx2]', TO_DATE('2017-11-03 19:40:32','YYYY-MM-DD HH24:MI:SS'), '更新操作', 1);
INSERT INTO t_log VALUES (2563, '查询商品信息', TO_DATE('2017-11-03 19:40:32','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2564, '查询商品信息（无库存）', TO_DATE('2017-11-03 19:40:37','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2565, '查询商品信息（无库存）', TO_DATE('2017-11-03 19:40:40','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2566, '查询商品信息（无库存）', TO_DATE('2017-11-03 19:40:40','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2567, '查询商品信息（无库存）', TO_DATE('2017-11-03 19:40:42','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2568, '查询商品信息（无库存）', TO_DATE('2017-11-03 19:40:43','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2569, '修改商品[id=24, code=0015, name= iPhone X, model=X, unit=台, purchasingPrice=8000.0, sellingPrice=9500.0, inventoryQuantity=50, minNum=100, producer=xx2, remarks=xxx2]，价格=8000.0,库存=50', TO_DATE('2017-11-03 19:41:01','YYYY-MM-DD HH24:MI:SS'), '更新操作', 1);
INSERT INTO t_log VALUES (2570, '查询商品信息（无库存）', TO_DATE('2017-11-03 19:41:01','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2571, '查询商品信息（有库存）', TO_DATE('2017-11-03 19:41:01','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2572, '查询商品信息（有库存）', TO_DATE('2017-11-03 19:41:04','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2573, '查询商品信息（无库存）', TO_DATE('2017-11-03 19:41:13','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2574, '查询商品信息（有库存）', TO_DATE('2017-11-03 19:41:13','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2575, '查询商品类别信息', TO_DATE('2017-11-03 19:46:21','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2576, '查询商品信息', TO_DATE('2017-11-03 19:46:21','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2577, '查询商品单位信息', TO_DATE('2017-11-03 19:46:21','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2578, '查询商品信息', TO_DATE('2017-11-03 19:46:21','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2579, '查询商品单位信息', TO_DATE('2017-11-03 19:46:21','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2580, '查询商品类别信息', TO_DATE('2017-11-03 19:46:28','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2581, '查询角色信息', TO_DATE('2017-11-03 19:47:11','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2582, '查询角色信息', TO_DATE('2017-11-03 19:47:11','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2583, '添加角色信息[id=null, name=xx, remarks=]', TO_DATE('2017-11-03 19:47:20','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2584, '查询角色信息', TO_DATE('2017-11-03 19:47:20','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2585, '添加角色信息[id=null, name=xx2, remarks=x]', TO_DATE('2017-11-03 19:47:24','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2586, '查询角色信息', TO_DATE('2017-11-03 19:47:24','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2587, '更新角色信息[id=11, name=xx23, remarks=x3]', TO_DATE('2017-11-03 19:47:29','YYYY-MM-DD HH24:MI:SS'), '更新操作', 1);
INSERT INTO t_log VALUES (2588, '查询角色信息', TO_DATE('2017-11-03 19:47:29','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2589, '删除角色信息[id=11, name=xx23, remarks=x3]', TO_DATE('2017-11-03 19:47:42','YYYY-MM-DD HH24:MI:SS'), '删除操作', 1);
INSERT INTO t_log VALUES (2590, '查询角色信息', TO_DATE('2017-11-03 19:47:42','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2591, '删除角色信息[id=10, name=xx, remarks=]', TO_DATE('2017-11-03 19:47:45','YYYY-MM-DD HH24:MI:SS'), '删除操作', 1);
INSERT INTO t_log VALUES (2592, '查询角色信息', TO_DATE('2017-11-03 19:47:45','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2593, '保存角色权限设置', TO_DATE('2017-11-03 19:48:30','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2594, '查询角色信息', TO_DATE('2017-11-03 19:48:40','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2595, '查询角色信息', TO_DATE('2017-11-03 19:48:42','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2596, '查询用户信息', TO_DATE('2017-11-03 19:48:51','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2597, '查询用户信息', TO_DATE('2017-11-03 19:48:51','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2598, '查询所有角色信息', TO_DATE('2017-11-03 19:48:56','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2599, '查询所有角色信息', TO_DATE('2017-11-03 19:49:02','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2600, '保存用户角色设置', TO_DATE('2017-11-03 19:49:03','YYYY-MM-DD HH24:MI:SS'), '更新操作', 1);
INSERT INTO t_log VALUES (2601, '查询用户信息', TO_DATE('2017-11-03 19:49:03','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2602, '查询所有角色信息', TO_DATE('2017-11-03 19:49:05','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2603, '用户注销', TO_DATE('2017-11-03 19:49:14','YYYY-MM-DD HH24:MI:SS'), '注销操作', 1);
INSERT INTO t_log VALUES (2604, '用户登录', TO_DATE('2017-11-03 19:49:22','YYYY-MM-DD HH24:MI:SS'), '登录操作', 3);
INSERT INTO t_log VALUES (2605, '查询商品库存信息', TO_DATE('2017-11-03 19:49:25','YYYY-MM-DD HH24:MI:SS'), '查询操作', 3);
INSERT INTO t_log VALUES (2606, '查询商品类别信息', TO_DATE('2017-11-03 19:49:45','YYYY-MM-DD HH24:MI:SS'), '查询操作', 3);
INSERT INTO t_log VALUES (2607, '查询商品库存信息', TO_DATE('2017-11-03 19:49:47','YYYY-MM-DD HH24:MI:SS'), '查询操作', 3);
INSERT INTO t_log VALUES (2608, '查询商品类别信息', TO_DATE('2017-11-03 19:49:48','YYYY-MM-DD HH24:MI:SS'), '查询操作', 3);
INSERT INTO t_log VALUES (2609, '查询商品库存信息', TO_DATE('2017-11-03 19:49:51','YYYY-MM-DD HH24:MI:SS'), '查询操作', 3);
INSERT INTO t_log VALUES (2610, '查询商品库存信息', TO_DATE('2017-11-03 19:49:54','YYYY-MM-DD HH24:MI:SS'), '查询操作', 3);
INSERT INTO t_log VALUES (2611, '查询商品库存信息', TO_DATE('2017-11-03 19:49:58','YYYY-MM-DD HH24:MI:SS'), '查询操作', 3);
INSERT INTO t_log VALUES (2612, '查询商品库存信息', TO_DATE('2017-11-03 19:49:59','YYYY-MM-DD HH24:MI:SS'), '查询操作', 3);
INSERT INTO t_log VALUES (2613, '用户登录', TO_DATE('2017-11-03 19:50:15','YYYY-MM-DD HH24:MI:SS'), '登录操作', 3);
INSERT INTO t_log VALUES (2614, '查询商品库存信息', TO_DATE('2017-11-03 19:50:17','YYYY-MM-DD HH24:MI:SS'), '查询操作', 3);
INSERT INTO t_log VALUES (2615, '用户登录', TO_DATE('2017-11-03 19:50:42','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2616, '查询商品库存信息', TO_DATE('2017-11-03 19:50:42','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2617, '用户登录', TO_DATE('2017-11-03 19:56:23','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2618, '查询商品库存信息', TO_DATE('2017-11-03 19:56:24','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2619, '用户登录', TO_DATE('2017-11-03 19:58:41','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2620, '查询商品库存信息', TO_DATE('2017-11-03 19:58:41','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2621, '修改密码', TO_DATE('2017-11-03 20:03:18','YYYY-MM-DD HH24:MI:SS'), '更新操作', 1);
INSERT INTO t_log VALUES (2622, '用户注销', TO_DATE('2017-11-03 20:03:20','YYYY-MM-DD HH24:MI:SS'), '注销操作', 1);
INSERT INTO t_log VALUES (2623, '用户登录', TO_DATE('2017-11-03 20:03:27','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2624, '查询商品库存信息', TO_DATE('2017-11-03 20:03:27','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2625, '查询商品信息', TO_DATE('2017-11-03 20:03:30','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2626, '查询商品信息', TO_DATE('2017-11-03 20:03:30','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2627, '查询商品类别信息', TO_DATE('2017-11-03 20:04:10','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2628, '查询商品信息', TO_DATE('2017-11-03 20:04:12','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2629, '查询商品信息', TO_DATE('2017-11-03 20:04:13','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2630, '查询商品信息', TO_DATE('2017-11-03 20:04:13','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2631, '查询商品信息', TO_DATE('2017-11-03 20:04:14','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2632, '添加商品类别信息[id=null, name=是, state=0, icon=icon-folder, pId=1]', TO_DATE('2017-11-03 20:04:50','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2633, '查询商品类别信息', TO_DATE('2017-11-03 20:04:50','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2634, '查询商品信息', TO_DATE('2017-11-03 20:04:51','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2635, '删除商品类别信息[id=20, name=是, state=0, icon=icon-folder, pId=1]', TO_DATE('2017-11-03 20:04:52','YYYY-MM-DD HH24:MI:SS'), '删除操作', 1);
INSERT INTO t_log VALUES (2636, '查询商品类别信息', TO_DATE('2017-11-03 20:04:52','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2637, '查询商品信息', TO_DATE('2017-11-03 20:05:40','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2638, '查询商品信息', TO_DATE('2017-11-03 20:05:40','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2639, '查询商品信息', TO_DATE('2017-11-03 20:05:41','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2640, '查询商品信息', TO_DATE('2017-11-03 20:05:41','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2641, '查询商品信息', TO_DATE('2017-11-03 20:05:42','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2642, '查询商品信息', TO_DATE('2017-11-03 20:05:43','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2643, '查询商品信息', TO_DATE('2017-11-03 20:05:43','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2644, '查询商品信息', TO_DATE('2017-11-03 20:05:44','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2645, '查询商品信息', TO_DATE('2017-11-03 20:05:44','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2646, '查询商品信息', TO_DATE('2017-11-03 20:05:45','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2647, '添加进货单', TO_DATE('2017-11-03 20:06:22','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2648, '查询商品信息', TO_DATE('2017-11-03 20:06:23','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2649, '查询商品信息', TO_DATE('2017-11-03 20:06:23','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2650, '删除进货单信息null', TO_DATE('2017-11-03 20:07:18','YYYY-MM-DD HH24:MI:SS'), '删除操作', 1);
INSERT INTO t_log VALUES (2651, '查询商品信息', TO_DATE('2017-11-03 20:07:22','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2652, '查询商品信息', TO_DATE('2017-11-03 20:07:22','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2653, '查询商品类别信息', TO_DATE('2017-11-03 20:07:52','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2654, '查询商品信息', TO_DATE('2017-11-03 20:07:58','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2655, '查询商品信息', TO_DATE('2017-11-03 20:08:03','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2656, '查询商品信息', TO_DATE('2017-11-03 20:08:09','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2657, '查询商品信息', TO_DATE('2017-11-03 20:08:09','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2658, '查询商品信息', TO_DATE('2017-11-03 20:08:11','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2659, '查询商品信息', TO_DATE('2017-11-03 20:08:16','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2660, '查询商品信息', TO_DATE('2017-11-03 20:08:17','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2661, '添加进货单', TO_DATE('2017-11-03 20:08:25','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2662, '查询商品信息', TO_DATE('2017-11-03 20:08:26','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2663, '查询商品信息', TO_DATE('2017-11-03 20:08:26','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2664, '查询商品信息', TO_DATE('2017-11-03 20:08:28','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2665, '查询商品信息', TO_DATE('2017-11-03 20:08:28','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2666, '查询商品类别信息', TO_DATE('2017-11-03 20:08:38','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2667, '查询商品信息', TO_DATE('2017-11-03 20:08:43','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2668, '查询商品信息', TO_DATE('2017-11-03 20:08:44','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2669, '查询商品信息', TO_DATE('2017-11-03 20:08:44','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2670, '添加商品类别信息[id=null, name=cc, state=0, icon=icon-folder, pId=1]', TO_DATE('2017-11-03 20:08:47','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2671, '查询商品类别信息', TO_DATE('2017-11-03 20:08:47','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2672, '查询商品信息', TO_DATE('2017-11-03 20:08:48','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2673, '添加商品类别信息[id=null, name=cc, state=0, icon=icon-folder, pId=21]', TO_DATE('2017-11-03 20:08:50','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2674, '查询商品类别信息', TO_DATE('2017-11-03 20:08:50','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2675, '查询商品信息', TO_DATE('2017-11-03 20:08:52','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2676, '查询商品信息', TO_DATE('2017-11-03 20:08:52','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2677, '删除商品类别信息[id=22, name=cc, state=0, icon=icon-folder, pId=21]', TO_DATE('2017-11-03 20:08:53','YYYY-MM-DD HH24:MI:SS'), '删除操作', 1);
INSERT INTO t_log VALUES (2678, '查询商品类别信息', TO_DATE('2017-11-03 20:08:53','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2679, '查询商品信息', TO_DATE('2017-11-03 20:08:53','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2680, '删除商品类别信息[id=21, name=cc, state=0, icon=icon-folder, pId=1]', TO_DATE('2017-11-03 20:08:54','YYYY-MM-DD HH24:MI:SS'), '删除操作', 1);
INSERT INTO t_log VALUES (2681, '查询商品类别信息', TO_DATE('2017-11-03 20:08:54','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2682, '查询商品信息', TO_DATE('2017-11-03 20:08:55','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2683, '查询商品信息', TO_DATE('2017-11-03 20:08:56','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2684, '查询商品信息', TO_DATE('2017-11-03 20:08:56','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2685, '查询商品信息', TO_DATE('2017-11-03 20:08:57','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2686, '查询商品信息', TO_DATE('2017-11-03 20:08:58','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2687, '查询商品信息', TO_DATE('2017-11-03 20:08:59','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2688, '查询商品类别信息', TO_DATE('2017-11-03 20:09:18','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2689, '查询商品信息', TO_DATE('2017-11-03 20:09:18','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2690, '查询商品单位信息', TO_DATE('2017-11-03 20:09:18','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2691, '查询商品信息', TO_DATE('2017-11-03 20:09:18','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2692, '查询商品单位信息', TO_DATE('2017-11-03 20:09:18','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2693, '查询商品信息', TO_DATE('2017-11-03 20:09:25','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2694, '更新商品信息[id=24, code=0015, name= iPhone X, model=X, unit=台, purchasingPrice=8000.0, sellingPrice=9500.0, inventoryQuantity=0, minNum=100, producer=xx2, remarks=xxx2]', TO_DATE('2017-11-03 20:09:41','YYYY-MM-DD HH24:MI:SS'), '更新操作', 1);
INSERT INTO t_log VALUES (2695, '查询商品信息', TO_DATE('2017-11-03 20:09:41','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2696, '更新商品信息[id=24, code=0015, name= iPhone X, model=X, unit=台, purchasingPrice=8000.0, sellingPrice=9500.0, inventoryQuantity=0, minNum=100, producer=xx2, remarks=xxx2]', TO_DATE('2017-11-03 20:09:47','YYYY-MM-DD HH24:MI:SS'), '更新操作', 1);
INSERT INTO t_log VALUES (2697, '查询商品信息', TO_DATE('2017-11-03 20:09:47','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2698, '查询商品信息（无库存）', TO_DATE('2017-11-03 20:09:50','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2699, '查询商品信息（无库存）', TO_DATE('2017-11-03 20:09:50','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2700, '查询商品信息（有库存）', TO_DATE('2017-11-03 20:09:50','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2701, '查询商品信息（有库存）', TO_DATE('2017-11-03 20:09:50','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2702, '修改商品[id=24, code=0015, name= iPhone X, model=X, unit=台, purchasingPrice=8000.0, sellingPrice=9500.0, inventoryQuantity=50, minNum=100, producer=xx2, remarks=xxx2]，价格=8000.0,库存=50', TO_DATE('2017-11-03 20:10:01','YYYY-MM-DD HH24:MI:SS'), '更新操作', 1);
INSERT INTO t_log VALUES (2703, '查询商品信息（有库存）', TO_DATE('2017-11-03 20:10:01','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2704, '查询商品信息（无库存）', TO_DATE('2017-11-03 20:10:01','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2705, '查询商品信息（有库存）', TO_DATE('2017-11-03 20:10:02','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2706, '查询商品信息（有库存）', TO_DATE('2017-11-03 20:10:26','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2707, '查询商品信息（无库存）', TO_DATE('2017-11-03 20:10:26','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2708, '查询商品信息', TO_DATE('2017-11-03 20:10:29','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2709, '查询商品信息', TO_DATE('2017-11-03 20:10:31','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2710, '查询商品类别信息', TO_DATE('2017-11-03 20:10:52','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2711, '查询商品信息', TO_DATE('2017-11-03 20:10:55','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2712, '查询商品信息', TO_DATE('2017-11-03 20:11:21','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2713, '查询客户信息', TO_DATE('2017-11-03 20:20:52','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2714, '查询客户信息', TO_DATE('2017-11-03 20:20:52','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2715, '查询商品类别信息', TO_DATE('2017-11-03 20:21:20','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2716, '查询商品单位信息', TO_DATE('2017-11-03 20:21:20','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2717, '查询商品信息', TO_DATE('2017-11-03 20:21:20','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2718, '查询商品信息', TO_DATE('2017-11-03 20:21:20','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2719, '查询商品单位信息', TO_DATE('2017-11-03 20:21:20','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2720, '查询商品类别信息', TO_DATE('2017-11-03 20:21:22','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2721, '添加商品信息[id=null, code=0016, name=21, model=X, unit=盒, purchasingPrice=100.0, sellingPrice=120.0, inventoryQuantity=0, minNum=12, producer=32, remarks=21]', TO_DATE('2017-11-03 20:21:42','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2722, '查询商品信息', TO_DATE('2017-11-03 20:21:42','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2723, '查询商品信息（无库存）', TO_DATE('2017-11-03 20:22:00','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2724, '查询商品信息（有库存）', TO_DATE('2017-11-03 20:22:00','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2725, '查询商品信息（无库存）', TO_DATE('2017-11-03 20:22:00','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2726, '查询商品信息（有库存）', TO_DATE('2017-11-03 20:22:00','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2727, '修改商品[id=25, code=0016, name=21, model=X, unit=盒, purchasingPrice=100.0, sellingPrice=120.0, inventoryQuantity=100, minNum=12, producer=32, remarks=21]，价格=100.0,库存=100', TO_DATE('2017-11-03 20:22:15','YYYY-MM-DD HH24:MI:SS'), '更新操作', 1);
INSERT INTO t_log VALUES (2728, '查询商品信息（无库存）', TO_DATE('2017-11-03 20:22:15','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2729, '查询商品信息（有库存）', TO_DATE('2017-11-03 20:22:15','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2730, '查询商品信息（有库存）', TO_DATE('2017-11-03 20:22:24','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2731, '查询商品信息（有库存）', TO_DATE('2017-11-03 20:22:26','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2732, '查询商品信息（无库存）', TO_DATE('2017-11-03 20:22:26','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2733, '查询商品类别信息', TO_DATE('2017-11-03 20:22:58','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2734, '添加退货单', TO_DATE('2017-11-03 20:23:15','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2735, '查询商品信息', TO_DATE('2017-11-03 20:23:16','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2736, '查询商品信息', TO_DATE('2017-11-03 20:23:16','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2737, '查询商品类别信息', TO_DATE('2017-11-03 20:24:08','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2738, '查询商品类别信息', TO_DATE('2017-11-03 20:36:59','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2739, '查询商品单位信息', TO_DATE('2017-11-03 20:37:00','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2740, '查询商品信息', TO_DATE('2017-11-03 20:37:00','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2741, '查询商品信息', TO_DATE('2017-11-03 20:37:00','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2742, '查询商品单位信息', TO_DATE('2017-11-03 20:37:00','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2743, '查询商品类别信息', TO_DATE('2017-11-03 20:37:04','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2744, '查询商品库存信息', TO_DATE('2017-11-03 20:37:21','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2745, '查询商品类别信息', TO_DATE('2017-11-03 20:37:22','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2746, '查询商品库存信息', TO_DATE('2017-11-03 20:37:25','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2747, '查询商品库存信息', TO_DATE('2017-11-03 20:37:26','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2748, '查询商品类别信息', TO_DATE('2017-11-03 20:37:28','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2749, '查询商品库存信息', TO_DATE('2017-11-03 20:37:32','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2750, '查询商品库存信息', TO_DATE('2017-11-03 20:37:35','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2751, '查询商品信息', TO_DATE('2017-11-03 20:37:48','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2752, '添加商品信息[id=null, code=0017, name=Sony/索尼 ILCE-A6000L WIFI微单数码相机高清单电, model=ILCE-A6000L, unit=台, purchasingPrice=3000.0, sellingPrice=3650.0, inventoryQuantity=0, minNum=100, producer=xxx, remarks=xxx]', TO_DATE('2017-11-03 20:44:59','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2753, '查询商品信息', TO_DATE('2017-11-03 20:44:59','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2754, '添加商品信息[id=null, code=0018, name=Canon/佳能 IXUS 285 HS 数码相机 2020万像素高清拍摄, model=IXUS 285 HS, unit=台, purchasingPrice=800.0, sellingPrice=1299.0, inventoryQuantity=0, minNum=400, producer=xx, remarks=xxx]', TO_DATE('2017-11-03 20:45:33','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2755, '查询商品信息', TO_DATE('2017-11-03 20:45:33','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2756, '查询商品信息', TO_DATE('2017-11-03 20:45:41','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2757, '添加商品信息[id=null, code=0019, name=Golden Field/金河田 Q8电脑音响台式多媒体家用音箱低音炮重低音, model=Q8, unit=台, purchasingPrice=60.0, sellingPrice=129.0, inventoryQuantity=0, minNum=300, producer=xxxx, remarks=]', TO_DATE('2017-11-03 20:47:08','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2758, '查询商品信息', TO_DATE('2017-11-03 20:47:08','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2759, '查询商品信息', TO_DATE('2017-11-03 20:47:14','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2760, '查询商品信息', TO_DATE('2017-11-03 20:47:16','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2761, '查询商品信息', TO_DATE('2017-11-03 20:47:16','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2762, '查询商品信息', TO_DATE('2017-11-03 20:47:17','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2763, '查询商品信息', TO_DATE('2017-11-03 20:47:17','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2764, '查询商品信息', TO_DATE('2017-11-03 20:47:17','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2765, '查询商品信息', TO_DATE('2017-11-03 20:47:18','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2766, '添加商品信息[id=null, code=0020, name=Haier/海尔冰箱BCD-190WDPT双门电冰箱大两门冷藏冷冻, model=190WDPT, unit=台, purchasingPrice=1000.0, sellingPrice=1699.0, inventoryQuantity=0, minNum=50, producer=cc, remarks=]', TO_DATE('2017-11-03 20:48:10','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2767, '查询商品信息', TO_DATE('2017-11-03 20:48:10','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2768, '查询商品信息', TO_DATE('2017-11-03 20:48:19','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2769, '查询商品信息', TO_DATE('2017-11-03 20:48:20','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2770, '查询商品信息', TO_DATE('2017-11-03 20:48:21','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2771, '查询商品信息', TO_DATE('2017-11-03 20:48:21','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2772, '添加商品信息[id=null, code=0021, name=Xiaomi/小米 小米电视4A 32英寸 智能液晶平板电视机, model=4A , unit=台, purchasingPrice=700.0, sellingPrice=1199.0, inventoryQuantity=0, minNum=320, producer=cc, remarks=]', TO_DATE('2017-11-03 20:49:11','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2773, '查询商品信息', TO_DATE('2017-11-03 20:49:11','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2774, '查询商品信息', TO_DATE('2017-11-03 20:49:13','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2775, '查询商品信息', TO_DATE('2017-11-03 20:49:14','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2776, '查询商品信息', TO_DATE('2017-11-03 20:49:15','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2777, '添加商品信息[id=null, code=0022, name=TCL XQB55-36SP 5.5公斤全自动波轮迷你小型洗衣机家用单脱抗菌, model=XQB55-36SP, unit=台, purchasingPrice=400.0, sellingPrice=729.0, inventoryQuantity=0, minNum=40, producer=cc, remarks=]', TO_DATE('2017-11-03 20:49:46','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2778, '查询商品信息', TO_DATE('2017-11-03 20:49:46','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2779, '查询商品信息', TO_DATE('2017-11-03 20:49:48','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2780, '查询商品信息', TO_DATE('2017-11-03 20:49:49','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2781, '查询商品信息', TO_DATE('2017-11-03 20:49:49','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2782, '添加商品信息[id=null, code=0023, name=台湾进口膨化零食品张君雅小妹妹日式串烧丸子80g*2, model=80g*2, unit=袋, purchasingPrice=4.0, sellingPrice=15.0, inventoryQuantity=0, minNum=1000, producer=cc, remarks=]', TO_DATE('2017-11-03 20:50:34','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2783, '查询商品信息', TO_DATE('2017-11-03 20:50:34','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2784, '查询商品信息', TO_DATE('2017-11-03 20:50:37','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2785, '查询商品信息', TO_DATE('2017-11-03 20:50:38','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2786, '查询商品信息', TO_DATE('2017-11-03 20:50:38','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2787, '删除商品单位信息[id=9, name=扫]', TO_DATE('2017-11-03 20:51:09','YYYY-MM-DD HH24:MI:SS'), '删除操作', 1);
INSERT INTO t_log VALUES (2788, '查询商品单位信息', TO_DATE('2017-11-03 20:51:09','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2789, '添加商品单位信息[id=null, name=件]', TO_DATE('2017-11-03 20:51:18','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2790, '查询商品单位信息', TO_DATE('2017-11-03 20:51:18','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2791, '添加商品信息[id=null, code=0024, name=卓图女装立领针织格子印花拼接高腰A字裙2017秋冬新款碎花连衣裙, model=A字裙, unit=件, purchasingPrice=168.0, sellingPrice=298.0, inventoryQuantity=0, minNum=10, producer=cc, remarks=]', TO_DATE('2017-11-03 20:51:32','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2792, '查询商品信息', TO_DATE('2017-11-03 20:51:32','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2793, '查询商品信息', TO_DATE('2017-11-03 20:51:33','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2794, '添加商品信息[id=null, code=0025, name=西服套装男三件套秋季新款商务修身职业正装男士西装新郎结婚礼服, model=三件套秋, unit=件, purchasingPrice=189.0, sellingPrice=299.0, inventoryQuantity=0, minNum=10, producer=cc, remarks=]', TO_DATE('2017-11-03 20:52:14','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2795, '查询商品信息', TO_DATE('2017-11-03 20:52:14','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2796, '查询商品信息', TO_DATE('2017-11-03 20:52:15','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2797, '添加商品单位信息[id=null, name=条]', TO_DATE('2017-11-03 20:52:50','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2798, '查询商品单位信息', TO_DATE('2017-11-03 20:52:50','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2799, '添加商品信息[id=null, code=0026, name=加绒加厚正品AFS JEEP/战地吉普男大码长裤植绒保暖男士牛仔裤子, model=AFS JEEP, unit=条, purchasingPrice=60.0, sellingPrice=89.0, inventoryQuantity=0, minNum=10, producer=c, remarks=]', TO_DATE('2017-11-03 20:53:04','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2800, '查询商品信息', TO_DATE('2017-11-03 20:53:04','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2801, '查询商品信息', TO_DATE('2017-11-03 20:53:06','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2802, '查询商品信息', TO_DATE('2017-11-03 20:53:06','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2803, '查询商品库存信息', TO_DATE('2017-11-03 20:53:11','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2804, '查询商品库存信息', TO_DATE('2017-11-03 20:53:14','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2805, '查询商品库存信息', TO_DATE('2017-11-03 20:53:15','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2806, '查询商品库存信息', TO_DATE('2017-11-03 20:53:23','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2807, '查询商品库存信息', TO_DATE('2017-11-03 20:53:25','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2808, '查询商品类别信息', TO_DATE('2017-11-03 20:53:47','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2809, '查询商品信息', TO_DATE('2017-11-03 20:53:50','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2810, '添加进货单', TO_DATE('2017-11-03 20:54:04','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2811, '查询商品信息', TO_DATE('2017-11-03 20:54:06','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2812, '查询商品信息', TO_DATE('2017-11-03 20:54:06','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2813, '查询商品库存信息', TO_DATE('2017-11-03 20:54:07','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2814, '查询商品库存信息', TO_DATE('2017-11-03 20:54:11','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2815, '查询商品信息', TO_DATE('2017-11-03 20:54:16','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2816, '查询商品信息', TO_DATE('2017-11-03 20:54:16','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2817, '查询商品类别信息', TO_DATE('2017-11-03 20:54:18','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2818, '查询商品类别信息', TO_DATE('2017-11-03 20:54:28','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2819, '查询商品类别信息', TO_DATE('2017-11-03 20:54:44','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2820, '查询商品类别信息', TO_DATE('2017-11-03 20:54:58','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2821, '添加销售单', TO_DATE('2017-11-03 20:55:08','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2822, '查询商品信息', TO_DATE('2017-11-03 20:55:09','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2823, '查询商品信息', TO_DATE('2017-11-03 20:55:09','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2824, '查询商品信息', TO_DATE('2017-11-03 20:55:09','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2825, '查询商品信息', TO_DATE('2017-11-03 20:55:09','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2826, '查询商品类别信息', TO_DATE('2017-11-03 20:55:10','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2827, '添加客户退货单', TO_DATE('2017-11-03 20:55:18','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2828, '查询商品信息', TO_DATE('2017-11-03 20:55:19','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2829, '查询商品信息', TO_DATE('2017-11-03 20:55:19','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2830, '查询商品类别信息', TO_DATE('2017-11-03 20:55:31','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2831, '添加销售单', TO_DATE('2017-11-03 20:55:35','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2832, '查询商品信息', TO_DATE('2017-11-03 20:55:36','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2833, '查询商品信息', TO_DATE('2017-11-03 20:55:36','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2834, '删除销售单信息null', TO_DATE('2017-11-03 20:56:16','YYYY-MM-DD HH24:MI:SS'), '删除操作', 1);
INSERT INTO t_log VALUES (2835, '查询商品信息', TO_DATE('2017-11-03 20:56:24','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2836, '查询商品信息', TO_DATE('2017-11-03 20:56:24','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2837, '查询商品类别信息', TO_DATE('2017-11-03 20:56:25','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2838, '添加报损单', TO_DATE('2017-11-03 20:56:31','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2839, '查询商品信息', TO_DATE('2017-11-03 20:56:32','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2840, '查询商品信息', TO_DATE('2017-11-03 20:56:32','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2841, '查询商品信息', TO_DATE('2017-11-03 20:56:48','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2842, '查询商品信息', TO_DATE('2017-11-03 20:56:49','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2843, '查询商品类别信息', TO_DATE('2017-11-03 20:58:56','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2844, '添加销售单', TO_DATE('2017-11-03 20:59:10','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2845, '查询商品信息', TO_DATE('2017-11-03 20:59:11','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2846, '查询商品信息', TO_DATE('2017-11-03 20:59:11','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2847, '查询商品类别信息', TO_DATE('2017-11-03 20:59:13','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2848, '查询商品类别信息', TO_DATE('2017-11-03 20:59:18','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2849, '查询商品信息', TO_DATE('2017-11-03 20:59:19','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2850, '查询商品信息', TO_DATE('2017-11-03 20:59:19','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2851, '查询商品信息', TO_DATE('2017-11-03 20:59:20','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2852, '查询商品信息', TO_DATE('2017-11-03 20:59:20','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2853, '添加销售单', TO_DATE('2017-11-03 20:59:28','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2854, '查询商品信息', TO_DATE('2017-11-03 20:59:29','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2855, '查询商品信息', TO_DATE('2017-11-03 20:59:29','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2856, '查询商品类别信息', TO_DATE('2017-11-03 20:59:31','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2857, '添加销售单', TO_DATE('2017-11-03 20:59:37','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2858, '查询商品信息', TO_DATE('2017-11-03 20:59:38','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2859, '查询商品信息', TO_DATE('2017-11-03 20:59:38','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2860, '查询商品类别信息', TO_DATE('2017-11-03 20:59:39','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2861, '添加销售单', TO_DATE('2017-11-03 20:59:48','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2862, '查询商品信息', TO_DATE('2017-11-03 20:59:50','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2863, '查询商品信息', TO_DATE('2017-11-03 20:59:50','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2864, '查询商品类别信息', TO_DATE('2017-11-03 20:59:51','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2865, '添加销售单', TO_DATE('2017-11-03 21:00:01','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2866, '查询商品信息', TO_DATE('2017-11-03 21:00:02','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2867, '查询商品信息', TO_DATE('2017-11-03 21:00:02','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2868, '查询商品类别信息', TO_DATE('2017-11-03 21:00:03','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2869, '添加销售单', TO_DATE('2017-11-03 21:00:16','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2870, '查询商品信息', TO_DATE('2017-11-03 21:00:17','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2871, '查询商品信息', TO_DATE('2017-11-03 21:00:17','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2872, '查询商品类别信息', TO_DATE('2017-11-03 21:00:18','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2873, '添加销售单', TO_DATE('2017-11-03 21:00:27','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2874, '查询商品信息', TO_DATE('2017-11-03 21:00:28','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2875, '查询商品信息', TO_DATE('2017-11-03 21:00:28','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2876, '查询商品类别信息', TO_DATE('2017-11-03 21:06:58','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2877, '查询商品类别信息', TO_DATE('2017-11-03 21:07:06','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2878, '添加销售单', TO_DATE('2017-11-03 21:07:18','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2879, '查询商品信息', TO_DATE('2017-11-03 21:07:20','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2880, '查询商品信息', TO_DATE('2017-11-03 21:07:20','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2881, '查询商品类别信息', TO_DATE('2017-11-03 21:07:30','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2882, '查询商品信息', TO_DATE('2017-11-03 21:07:32','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2883, '添加销售单', TO_DATE('2017-11-03 21:07:43','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2884, '查询商品信息', TO_DATE('2017-11-03 21:07:45','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2885, '查询商品信息', TO_DATE('2017-11-03 21:07:45','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2886, '查询商品类别信息', TO_DATE('2017-11-03 21:07:46','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2887, '添加销售单', TO_DATE('2017-11-03 21:07:53','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2888, '查询商品信息', TO_DATE('2017-11-03 21:07:55','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2889, '查询商品信息', TO_DATE('2017-11-03 21:07:55','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2890, '查询商品类别信息', TO_DATE('2017-11-03 21:07:59','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2891, '查询商品信息', TO_DATE('2017-11-03 21:08:06','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2892, '添加销售单', TO_DATE('2017-11-03 21:08:09','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2893, '查询商品信息', TO_DATE('2017-11-03 21:08:10','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2894, '查询商品信息', TO_DATE('2017-11-03 21:08:10','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2895, '查询商品类别信息', TO_DATE('2017-11-03 21:08:12','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2896, '查询商品类别信息', TO_DATE('2017-11-03 21:08:20','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2897, '查询商品信息', TO_DATE('2017-11-03 21:08:21','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2898, '添加销售单', TO_DATE('2017-11-03 21:08:27','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (2899, '查询商品信息', TO_DATE('2017-11-03 21:08:28','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2900, '查询商品信息', TO_DATE('2017-11-03 21:08:28','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);

INSERT INTO t_log VALUES (2901, '查询商品类别信息', TO_DATE('2017-11-03 21:22:12','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2902, '查询商品类别信息', TO_DATE('2017-11-03 21:22:17','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2903, '查询商品信息', TO_DATE('2017-11-03 21:22:20','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2904, '查询商品信息', TO_DATE('2017-11-03 21:22:20','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2905, '查询商品类别信息', TO_DATE('2017-11-03 21:22:21','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2906, '查询商品库存信息', TO_DATE('2017-11-03 21:22:38','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2907, '查询商品信息', TO_DATE('2017-11-03 21:22:40','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2908, '查询商品信息', TO_DATE('2017-11-03 21:22:40','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2909, '查询商品库存信息', TO_DATE('2017-11-03 21:23:29','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2910, '查询客户信息', TO_DATE('2017-11-03 21:26:49','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2911, '查询客户信息', TO_DATE('2017-11-03 21:26:49','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2912, '查询用户信息', TO_DATE('2017-11-03 21:26:52','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2913, '查询用户信息', TO_DATE('2017-11-03 21:26:52','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2914, '查询角色信息', TO_DATE('2017-11-03 21:26:53','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2915, '查询角色信息', TO_DATE('2017-11-03 21:26:53','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2916, '查询商品信息', TO_DATE('2017-11-03 21:30:47','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2917, '查询商品信息', TO_DATE('2017-11-03 21:30:47','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2918, '查询商品库存信息', TO_DATE('2017-11-03 21:31:11','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2919, '用户登录', TO_DATE('2017-11-07 09:33:56','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2920, '查询商品库存信息', TO_DATE('2017-11-07 09:33:57','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2921, '查询商品信息', TO_DATE('2017-11-07 09:34:07','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2922, '查询商品信息', TO_DATE('2017-11-07 09:34:07','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2923, '查询商品信息', TO_DATE('2017-11-07 09:34:11','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2924, '查询商品信息', TO_DATE('2017-11-07 09:34:11','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2925, '查询商品库存信息', TO_DATE('2017-11-07 09:34:16','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2926, '查询商品类别信息', TO_DATE('2017-11-07 09:34:20','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2927, '查询商品信息', TO_DATE('2017-11-07 09:34:32','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2928, '查询商品信息', TO_DATE('2017-11-07 09:34:32','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2929, '查询商品信息', TO_DATE('2017-11-07 09:34:57','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2930, '查询商品信息', TO_DATE('2017-11-07 09:34:57','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2931, '查询商品信息', TO_DATE('2017-11-07 09:35:01','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2932, '查询商品信息', TO_DATE('2017-11-07 09:35:01','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2933, '查询商品库存信息', TO_DATE('2017-11-07 09:35:10','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2934, '查询供应商信息', TO_DATE('2017-11-07 09:35:37','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2935, '查询供应商信息', TO_DATE('2017-11-07 09:35:37','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2936, '查询客户信息', TO_DATE('2017-11-07 09:35:41','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2937, '查询客户信息', TO_DATE('2017-11-07 09:35:41','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2938, '查询商品类别信息', TO_DATE('2017-11-07 09:35:43','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2939, '查询商品信息', TO_DATE('2017-11-07 09:35:43','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2940, '查询商品单位信息', TO_DATE('2017-11-07 09:35:43','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2941, '查询商品信息', TO_DATE('2017-11-07 09:35:43','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2942, '查询商品单位信息', TO_DATE('2017-11-07 09:35:43','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2943, '查询角色信息', TO_DATE('2017-11-07 09:35:49','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2944, '查询角色信息', TO_DATE('2017-11-07 09:35:49','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2945, '查询用户信息', TO_DATE('2017-11-07 09:35:59','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2946, '查询用户信息', TO_DATE('2017-11-07 09:35:59','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2947, '查询商品信息', TO_DATE('2017-11-07 09:41:36','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2948, '查询商品信息', TO_DATE('2017-11-07 09:41:36','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2949, '查询商品库存信息', TO_DATE('2017-11-07 09:42:06','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2950, '查询商品库存信息', TO_DATE('2017-11-07 09:42:09','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2951, '查询商品库存信息', TO_DATE('2017-11-07 09:42:12','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2952, '查询商品库存信息', TO_DATE('2017-11-07 09:42:14','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2953, '查询商品库存信息', TO_DATE('2017-11-07 09:42:14','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2954, '查询商品库存信息', TO_DATE('2017-11-07 09:42:17','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2955, '查询商品库存信息', TO_DATE('2017-11-07 09:42:21','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2956, '查询商品库存信息', TO_DATE('2017-11-07 09:46:10','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2957, '查询商品信息', TO_DATE('2017-11-07 09:46:13','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2958, '查询商品信息', TO_DATE('2017-11-07 09:46:13','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2959, '查询商品类别信息', TO_DATE('2017-11-07 09:46:18','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2960, '查询商品信息', TO_DATE('2017-11-07 09:46:23','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2961, '查询商品信息', TO_DATE('2017-11-07 09:46:23','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2962, '查询商品信息', TO_DATE('2017-11-07 09:46:31','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2963, '查询商品信息', TO_DATE('2017-11-07 09:46:31','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2964, '用户登录', TO_DATE('2017-11-07 09:48:27','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2965, '查询商品库存信息', TO_DATE('2017-11-07 09:49:07','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2966, '查询商品信息', TO_DATE('2017-11-07 09:49:26','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2967, '查询商品信息', TO_DATE('2017-11-07 09:49:31','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2968, '查询商品信息', TO_DATE('2017-11-07 09:49:53','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2969, '查询商品信息', TO_DATE('2017-11-07 09:49:54','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2970, '查询商品信息', TO_DATE('2017-11-07 09:50:29','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2971, '查询商品信息', TO_DATE('2017-11-07 09:50:29','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2972, '查询角色信息', TO_DATE('2017-11-07 09:50:40','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2973, '查询角色信息', TO_DATE('2017-11-07 09:50:40','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2974, '查询用户信息', TO_DATE('2017-11-07 09:50:48','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2975, '查询用户信息', TO_DATE('2017-11-07 09:50:48','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2976, '查询商品信息', TO_DATE('2017-11-07 09:52:13','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2977, '查询商品信息', TO_DATE('2017-11-07 09:52:14','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2978, '????', TO_DATE('2019-01-18 13:22:11','YYYY-MM-DD HH24:MI:SS'), '????', 1);
INSERT INTO t_log VALUES (2979, '????????', TO_DATE('2019-01-18 13:22:16','YYYY-MM-DD HH24:MI:SS'), '????', 1);
INSERT INTO t_log VALUES (2980, '??????', TO_DATE('2019-01-18 13:22:21','YYYY-MM-DD HH24:MI:SS'), '????', 1);
INSERT INTO t_log VALUES (2981, '??????', TO_DATE('2019-01-18 13:22:21','YYYY-MM-DD HH24:MI:SS'), '????', 1);
INSERT INTO t_log VALUES (2982, '??????', TO_DATE('2019-01-18 13:22:23','YYYY-MM-DD HH24:MI:SS'), '????', 1);
INSERT INTO t_log VALUES (2983, '??????', TO_DATE('2019-01-18 13:22:24','YYYY-MM-DD HH24:MI:SS'), '????', 1);
INSERT INTO t_log VALUES (2984, '????????', TO_DATE('2019-01-18 13:22:27','YYYY-MM-DD HH24:MI:SS'), '????', 1);
INSERT INTO t_log VALUES (2985, '??????', TO_DATE('2019-01-18 13:22:28','YYYY-MM-DD HH24:MI:SS'), '????', 1);
INSERT INTO t_log VALUES (2986, '??????', TO_DATE('2019-01-18 13:22:29','YYYY-MM-DD HH24:MI:SS'), '????', 1);
INSERT INTO t_log VALUES (2987, '??????', TO_DATE('2019-01-18 13:22:48','YYYY-MM-DD HH24:MI:SS'), '????', 1);
INSERT INTO t_log VALUES (2988, '??????', TO_DATE('2019-01-18 13:22:48','YYYY-MM-DD HH24:MI:SS'), '????', 1);
INSERT INTO t_log VALUES (2989, '??????', TO_DATE('2019-01-18 13:22:50','YYYY-MM-DD HH24:MI:SS'), '????', 1);
INSERT INTO t_log VALUES (2990, '??????', TO_DATE('2019-01-18 13:22:50','YYYY-MM-DD HH24:MI:SS'), '????', 1);
INSERT INTO t_log VALUES (2991, '用户登录', TO_DATE('2019-01-18 13:27:25','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2992, '查询商品库存信息', TO_DATE('2019-01-18 13:27:28','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2993, '用户注销', TO_DATE('2019-01-18 13:29:18','YYYY-MM-DD HH24:MI:SS'), '注销操作', 1);
INSERT INTO t_log VALUES (2994, '用户登录', TO_DATE('2019-01-18 13:31:29','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (2995, '查询商品库存信息', TO_DATE('2019-01-18 13:31:31','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2996, '查询商品信息', TO_DATE('2019-01-18 13:31:50','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2997, '查询商品信息', TO_DATE('2019-01-18 13:31:51','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2998, '查询商品类别信息', TO_DATE('2019-01-18 13:31:52','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (2999, '查询商品信息', TO_DATE('2019-01-18 13:31:56','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3000, '用户注销', TO_DATE('2019-01-18 13:32:09','YYYY-MM-DD HH24:MI:SS'), '注销操作', 1);
INSERT INTO t_log VALUES (3001, '用户登录', TO_DATE('2019-01-18 13:36:53','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (3002, '查询商品库存信息', TO_DATE('2019-01-18 13:36:56','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3003, '查询用户信息', TO_DATE('2019-01-18 13:37:39','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3004, '查询用户信息', TO_DATE('2019-01-18 13:37:39','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3005, '查询商品信息', TO_DATE('2019-01-18 13:38:10','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3006, '查询商品信息', TO_DATE('2019-01-18 13:38:10','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3007, '查询商品库存信息', TO_DATE('2019-01-18 13:38:13','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3008, '查询用户信息', TO_DATE('2019-01-18 13:38:15','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3009, '查询用户信息', TO_DATE('2019-01-18 13:38:16','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3010, '查询商品库存信息', TO_DATE('2019-01-18 13:39:57','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3011, '查询商品库存信息', TO_DATE('2019-01-18 13:40:42','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3012, '用户注销', TO_DATE('2019-01-18 13:40:43','YYYY-MM-DD HH24:MI:SS'), '注销操作', 1);
INSERT INTO t_log VALUES (3013, '用户登录', TO_DATE('2019-01-18 13:40:56','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (3014, '查询商品库存信息', TO_DATE('2019-01-18 13:40:59','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3015, '查询商品库存信息', TO_DATE('2019-01-18 13:41:02','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3016, '用户登录', TO_DATE('2019-01-18 13:41:46','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (3017, '查询商品库存信息', TO_DATE('2019-01-18 13:41:51','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3018, '查询商品库存信息', TO_DATE('2019-01-18 13:42:24','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3019, '查询商品信息', TO_DATE('2019-01-18 13:42:31','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3020, '查询商品信息', TO_DATE('2019-01-18 13:42:32','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3021, '查询商品库存信息', TO_DATE('2019-01-18 13:43:39','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3022, '查询商品库存信息', TO_DATE('2019-01-18 13:43:43','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3023, '查询商品库存信息', TO_DATE('2019-01-18 13:43:47','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3024, '用户注销', TO_DATE('2019-01-18 13:43:50','YYYY-MM-DD HH24:MI:SS'), '注销操作', 1);
INSERT INTO t_log VALUES (3025, '用户登录', TO_DATE('2019-01-18 13:44:04','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (3026, '查询商品库存信息', TO_DATE('2019-01-18 13:44:06','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3027, '查询商品信息', TO_DATE('2019-01-18 13:44:24','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3028, '查询商品信息', TO_DATE('2019-01-18 13:44:25','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3029, '查询商品库存信息', TO_DATE('2019-01-18 13:44:30','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3030, '查询商品信息', TO_DATE('2019-01-18 13:44:36','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3031, '查询商品信息', TO_DATE('2019-01-18 13:44:36','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3032, '查询商品信息（无库存）', TO_DATE('2019-01-18 13:45:39','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3033, '查询商品信息（有库存）', TO_DATE('2019-01-18 13:45:39','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3034, '查询商品信息（无库存）', TO_DATE('2019-01-18 13:45:39','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3035, '查询商品信息（有库存）', TO_DATE('2019-01-18 13:45:39','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3036, '用户登录', TO_DATE('2021-02-02 15:13:42','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (3037, '查询商品库存信息', TO_DATE('2021-02-02 15:13:44','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3038, '查询商品信息', TO_DATE('2021-02-02 15:13:52','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3039, '查询商品信息', TO_DATE('2021-02-02 15:13:52','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3040, '查询商品信息', TO_DATE('2021-02-02 15:13:56','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3041, '查询商品信息', TO_DATE('2021-02-02 15:13:56','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3042, '查询商品库存信息', TO_DATE('2021-02-02 15:14:01','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3043, '查询商品信息', TO_DATE('2021-02-02 15:14:12','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3044, '查询商品信息', TO_DATE('2021-02-02 15:14:12','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3045, '查询商品信息', TO_DATE('2021-02-02 15:14:15','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3046, '查询商品信息', TO_DATE('2021-02-02 15:14:15','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3047, '查询供应商信息', TO_DATE('2021-02-02 15:14:27','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3048, '查询供应商信息', TO_DATE('2021-02-02 15:14:27','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3049, '查询商品类别信息', TO_DATE('2021-02-02 15:14:27','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3050, '查询商品信息', TO_DATE('2021-02-02 15:14:28','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3051, '查询商品单位信息', TO_DATE('2021-02-02 15:14:28','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3052, '查询商品信息', TO_DATE('2021-02-02 15:14:28','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3053, '查询商品单位信息', TO_DATE('2021-02-02 15:14:28','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3054, '查询角色信息', TO_DATE('2021-02-02 15:15:17','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3055, '查询角色信息', TO_DATE('2021-02-02 15:15:17','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3056, '查询用户信息', TO_DATE('2021-02-02 15:15:18','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3057, '查询用户信息', TO_DATE('2021-02-02 15:15:19','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3058, '查询所有角色信息', TO_DATE('2021-02-02 15:15:40','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3059, '查询商品库存信息', TO_DATE('2021-02-02 15:16:05','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3060, '查询商品库存信息', TO_DATE('2021-02-02 15:16:08','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3061, '用户登录', TO_DATE('2021-02-02 16:59:19','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (3062, '查询商品库存信息', TO_DATE('2021-02-02 16:59:20','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3063, '查询商品信息', TO_DATE('2021-02-02 16:59:37','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3064, '查询商品信息', TO_DATE('2021-02-02 16:59:37','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3065, '查询商品库存信息', TO_DATE('2021-02-02 16:59:59','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3066, '查询商品类别信息', TO_DATE('2021-02-02 17:00:14','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3067, '查询商品信息', TO_DATE('2021-02-02 17:00:22','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3068, '查询商品信息', TO_DATE('2021-02-02 17:00:30','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3069, '查询商品信息', TO_DATE('2021-02-02 17:00:32','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3070, '查询商品信息', TO_DATE('2021-02-02 17:00:34','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3071, '查询商品信息', TO_DATE('2021-02-02 17:00:35','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3072, '查询商品信息', TO_DATE('2021-02-02 17:00:36','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3073, '查询商品类别信息', TO_DATE('2021-02-02 17:01:00','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3074, '查询商品信息', TO_DATE('2021-02-02 17:01:04','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3075, '查询商品信息', TO_DATE('2021-02-02 17:01:33','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3076, '查询商品信息', TO_DATE('2021-02-02 17:01:53','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3077, '查询商品信息', TO_DATE('2021-02-02 17:01:53','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3078, '查询商品类别信息', TO_DATE('2021-02-02 17:01:55','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3079, '查询商品信息', TO_DATE('2021-02-02 17:01:59','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3080, '查询商品信息', TO_DATE('2021-02-02 17:02:09','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3081, '查询商品信息', TO_DATE('2021-02-02 17:02:18','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3082, '查询商品信息', TO_DATE('2021-02-02 17:02:23','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3083, '查询商品信息', TO_DATE('2021-02-02 17:02:23','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3084, '查询商品类别信息', TO_DATE('2021-02-02 17:02:26','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3085, '查询商品信息', TO_DATE('2021-02-02 17:02:41','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3086, '查询商品信息', TO_DATE('2021-02-02 17:02:41','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3087, '查询商品类别信息', TO_DATE('2021-02-02 17:02:42','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3088, '查询商品库存信息', TO_DATE('2021-02-02 17:03:10','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3089, '查询供应商信息', TO_DATE('2021-02-02 17:03:12','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3090, '查询供应商信息', TO_DATE('2021-02-02 17:03:12','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3091, '查询客户信息', TO_DATE('2021-02-02 17:03:17','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3092, '查询客户信息', TO_DATE('2021-02-02 17:03:17','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3093, '查询商品类别信息', TO_DATE('2021-02-02 17:03:21','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3094, '查询商品单位信息', TO_DATE('2021-02-02 17:03:21','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3095, '查询商品信息', TO_DATE('2021-02-02 17:03:21','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3096, '查询商品单位信息', TO_DATE('2021-02-02 17:03:21','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3097, '查询商品信息', TO_DATE('2021-02-02 17:03:21','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3098, '查询商品信息', TO_DATE('2021-02-02 17:03:24','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3099, '查询商品信息（无库存）', TO_DATE('2021-02-02 17:03:33','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3100, '查询商品信息（有库存）', TO_DATE('2021-02-02 17:03:33','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3101, '查询商品信息（无库存）', TO_DATE('2021-02-02 17:03:33','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3102, '查询商品信息（有库存）', TO_DATE('2021-02-02 17:03:33','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3103, '查询用户信息', TO_DATE('2021-02-02 17:04:07','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3104, '查询用户信息', TO_DATE('2021-02-02 17:04:07','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3105, '用户登录', TO_DATE('2021-02-03 14:10:30','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (3106, '查询商品库存信息', TO_DATE('2021-02-03 14:10:32','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3107, '查询商品库存信息', TO_DATE('2021-02-03 14:10:52','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3108, '查询商品信息', TO_DATE('2021-02-03 14:14:17','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3109, '查询商品信息', TO_DATE('2021-02-03 14:14:17','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3110, '查询商品信息', TO_DATE('2021-02-03 14:14:23','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3111, '查询商品信息', TO_DATE('2021-02-03 14:14:23','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3112, '查询商品库存信息', TO_DATE('2021-02-03 14:14:34','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3113, '查询商品类别信息', TO_DATE('2021-02-03 14:14:42','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3114, '查询商品信息', TO_DATE('2021-02-03 14:14:57','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3115, '查询商品信息', TO_DATE('2021-02-03 14:15:19','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3116, '查询商品类别信息', TO_DATE('2021-02-03 14:15:51','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3117, '查询商品类别信息', TO_DATE('2021-02-03 14:16:18','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3118, '查询供应商信息', TO_DATE('2021-02-03 14:16:46','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3119, '查询供应商信息', TO_DATE('2021-02-03 14:16:46','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3120, '查询客户信息', TO_DATE('2021-02-03 14:16:49','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3121, '查询客户信息', TO_DATE('2021-02-03 14:16:49','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3122, '查询商品类别信息', TO_DATE('2021-02-03 14:16:52','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3123, '查询商品信息', TO_DATE('2021-02-03 14:16:53','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3124, '查询商品单位信息', TO_DATE('2021-02-03 14:16:53','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3125, '查询商品单位信息', TO_DATE('2021-02-03 14:16:53','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3126, '查询商品信息', TO_DATE('2021-02-03 14:16:53','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3127, '查询商品信息（无库存）', TO_DATE('2021-02-03 14:16:57','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3128, '查询商品信息（有库存）', TO_DATE('2021-02-03 14:16:57','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3129, '查询商品信息（无库存）', TO_DATE('2021-02-03 14:16:57','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3130, '查询商品信息（有库存）', TO_DATE('2021-02-03 14:16:57','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3131, '查询角色信息', TO_DATE('2021-02-03 14:17:15','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3132, '查询角色信息', TO_DATE('2021-02-03 14:17:15','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3133, '用户登录', TO_DATE('2021-02-03 15:02:21','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (3134, '查询商品库存信息', TO_DATE('2021-02-03 15:02:22','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3135, '用户登录', TO_DATE('2021-02-03 15:31:40','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (3136, '查询商品库存信息', TO_DATE('2021-02-03 15:31:41','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3137, '查询商品信息', TO_DATE('2021-02-03 15:31:53','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3138, '查询商品信息', TO_DATE('2021-02-03 15:31:53','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3139, '查询角色信息', TO_DATE('2021-02-03 15:32:09','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3140, '查询角色信息', TO_DATE('2021-02-03 15:32:09','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3141, '查询用户信息', TO_DATE('2021-02-03 15:32:10','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3142, '查询用户信息', TO_DATE('2021-02-03 15:32:10','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3143, '查询商品类别信息', TO_DATE('2021-02-03 15:32:53','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3144, '查询商品信息', TO_DATE('2021-02-03 15:33:26','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3145, '查询商品信息', TO_DATE('2021-02-03 15:33:30','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3146, '查询商品信息', TO_DATE('2021-02-03 15:33:31','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3147, '查询商品信息', TO_DATE('2021-02-03 15:33:32','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3148, '查询商品信息', TO_DATE('2021-02-03 15:33:42','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3149, '查询商品信息', TO_DATE('2021-02-03 15:33:42','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3150, '查询商品类别信息', TO_DATE('2021-02-03 15:33:42','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3151, '查询商品信息', TO_DATE('2021-02-03 15:34:11','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3152, '查询商品信息', TO_DATE('2021-02-03 15:34:11','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3153, '查询商品类别信息', TO_DATE('2021-02-03 15:34:12','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3154, '查询商品库存信息', TO_DATE('2021-02-03 15:34:25','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3155, '查询商品信息', TO_DATE('2021-02-03 15:34:29','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3156, '查询商品信息', TO_DATE('2021-02-03 15:34:29','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3157, '查询商品类别信息', TO_DATE('2021-02-03 15:34:31','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3158, '查询商品信息', TO_DATE('2021-02-03 15:34:34','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3159, '查询商品信息', TO_DATE('2021-02-03 15:34:35','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3160, '查询供应商信息', TO_DATE('2021-02-03 15:34:40','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3161, '查询供应商信息', TO_DATE('2021-02-03 15:34:40','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3162, '查询客户信息', TO_DATE('2021-02-03 15:34:48','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3163, '查询客户信息', TO_DATE('2021-02-03 15:34:48','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3164, '查询商品类别信息', TO_DATE('2021-02-03 15:34:51','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3165, '查询商品单位信息', TO_DATE('2021-02-03 15:34:51','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3166, '查询商品信息', TO_DATE('2021-02-03 15:34:51','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3167, '查询商品单位信息', TO_DATE('2021-02-03 15:34:51','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3168, '查询商品信息', TO_DATE('2021-02-03 15:34:51','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3169, '添加商品类别信息[id=null, name=test, state=0, icon=icon-folder, pId=1]', TO_DATE('2021-02-03 15:35:03','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (3170, '查询商品类别信息', TO_DATE('2021-02-03 15:35:03','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3171, '查询商品信息', TO_DATE('2021-02-03 15:35:08','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3172, '查询商品信息', TO_DATE('2021-02-03 15:35:12','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3173, '添加商品类别信息[id=null, name=234234, state=0, icon=icon-folder, pId=18]', TO_DATE('2021-02-03 15:35:17','YYYY-MM-DD HH24:MI:SS'), '添加操作', 1);
INSERT INTO t_log VALUES (3174, '查询商品类别信息', TO_DATE('2021-02-03 15:35:17','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3175, '查询商品信息', TO_DATE('2021-02-03 15:35:19','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3176, '查询商品信息', TO_DATE('2021-02-03 15:35:20','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3177, '删除商品类别信息[id=19, name=234234, state=0, icon=icon-folder, pId=18]', TO_DATE('2021-02-03 15:35:21','YYYY-MM-DD HH24:MI:SS'), '删除操作', 1);
INSERT INTO t_log VALUES (3178, '查询商品类别信息', TO_DATE('2021-02-03 15:35:21','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3179, '查询商品信息', TO_DATE('2021-02-03 15:35:22','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3180, '删除商品类别信息[id=18, name=test, state=0, icon=icon-folder, pId=1]', TO_DATE('2021-02-03 15:35:25','YYYY-MM-DD HH24:MI:SS'), '删除操作', 1);
INSERT INTO t_log VALUES (3181, '查询商品类别信息', TO_DATE('2021-02-03 15:35:25','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3182, '查询商品信息', TO_DATE('2021-02-03 15:35:31','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3183, '查询商品信息', TO_DATE('2021-02-03 15:35:32','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3184, '查询商品信息', TO_DATE('2021-02-03 15:35:34','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3185, '查询商品信息', TO_DATE('2021-02-03 15:35:35','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3186, '查询商品信息', TO_DATE('2021-02-03 15:35:36','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3187, '查询商品信息', TO_DATE('2021-02-03 15:35:37','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3188, '查询商品信息', TO_DATE('2021-02-03 15:35:38','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3189, '查询商品信息', TO_DATE('2021-02-03 15:35:38','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3190, '查询商品信息', TO_DATE('2021-02-03 15:35:54','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3191, '查询商品信息', TO_DATE('2021-02-03 15:35:55','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3192, '查询商品信息', TO_DATE('2021-02-03 15:35:55','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3193, '查询商品信息', TO_DATE('2021-02-03 15:35:59','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3194, '查询商品信息', TO_DATE('2021-02-03 15:36:00','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3195, '查询商品信息', TO_DATE('2021-02-03 15:36:01','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3196, '查询商品信息', TO_DATE('2021-02-03 15:36:02','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3197, '用户登录', TO_DATE('2021-02-05 15:45:00','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (3198, '查询商品库存信息', TO_DATE('2021-02-05 15:45:02','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3199, '查询角色信息', TO_DATE('2021-02-05 15:45:13','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3200, '查询角色信息', TO_DATE('2021-02-05 15:45:13','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3201, '查询用户信息', TO_DATE('2021-02-05 15:45:14','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3202, '查询用户信息', TO_DATE('2021-02-05 15:45:14','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3203, '查询商品信息', TO_DATE('2021-02-05 15:46:30','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3204, '查询商品信息', TO_DATE('2021-02-05 15:46:30','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3205, '查询供应商信息', TO_DATE('2021-02-05 15:46:41','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3206, '查询供应商信息', TO_DATE('2021-02-05 15:46:41','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3207, '查询客户信息', TO_DATE('2021-02-05 15:46:42','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3208, '查询客户信息', TO_DATE('2021-02-05 15:46:42','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3209, '查询商品类别信息', TO_DATE('2021-02-05 15:46:42','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3210, '查询商品单位信息', TO_DATE('2021-02-05 15:46:43','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3211, '查询商品信息', TO_DATE('2021-02-05 15:46:43','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3212, '查询商品单位信息', TO_DATE('2021-02-05 15:46:43','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3213, '查询商品信息', TO_DATE('2021-02-05 15:46:43','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3214, '查询商品信息（无库存）', TO_DATE('2021-02-05 15:46:43','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3215, '查询商品信息（有库存）', TO_DATE('2021-02-05 15:46:43','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3216, '查询商品信息（无库存）', TO_DATE('2021-02-05 15:46:43','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3217, '查询商品信息（有库存）', TO_DATE('2021-02-05 15:46:43','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3218, '查询商品信息（有库存）', TO_DATE('2021-02-05 15:47:07','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3219, '用户登录', TO_DATE('2021-02-07 22:08:03','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (3220, '查询商品库存信息', TO_DATE('2021-02-07 22:08:05','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3221, '用户登录', TO_DATE('2021-02-18 16:19:55','YYYY-MM-DD HH24:MI:SS'), '登录操作', 1);
INSERT INTO t_log VALUES (3222, '查询商品库存信息', TO_DATE('2021-02-18 16:19:57','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3223, '查询角色信息', TO_DATE('2021-02-18 16:20:06','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3224, '查询角色信息', TO_DATE('2021-02-18 16:20:06','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3225, '查询用户信息', TO_DATE('2021-02-18 16:20:07','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);
INSERT INTO t_log VALUES (3226, '查询用户信息', TO_DATE('2021-02-18 16:20:07','YYYY-MM-DD HH24:MI:SS'), '查询操作', 1);


-- 菜单表（t_menu）数据
INSERT INTO t_menu VALUES (1, 'menu-1', '系统菜单', 1, '/', -1, '2099', -1, 0);
INSERT INTO t_menu VALUES (2, 'menu-2', '系统设置', 0, '/', 1, '10', 0, 0);
INSERT INTO t_menu VALUES (3, 'menu-3', '用户管理', 0, '/user/index', 2, '1010', 1, 0);
INSERT INTO t_menu VALUES (4, 'menu-4', '角色管理', 0, '/role/index', 2, '1020', 1, 0);
INSERT INTO t_menu VALUES (5, 'menu-5', '密码修改', 0, '/user/toPasswordPage', 2, '101001', 2, 0);
INSERT INTO t_menu VALUES (6, 'menu-6', '安全退出', 0, '/signout', 2, '101002', 2, 0);
INSERT INTO t_menu VALUES (7, NULL, '用户列表查询', 0, NULL, 3, '101003', 2, 0);
INSERT INTO t_menu VALUES (8, NULL, '用户添加', 0, NULL, 3, '101004', 2, 0);
INSERT INTO t_menu VALUES (9, NULL, '用户更新', 0, NULL, 3, '101005', 2, 0);
INSERT INTO t_menu VALUES (10, NULL, '用户删除', 0, NULL, 3, '101006', 2, 0);
INSERT INTO t_menu VALUES (11, NULL, '角色列表查询', 0, NULL, 4, '102001', 2, 0);
INSERT INTO t_menu VALUES (12, NULL, '角色添加', 0, NULL, 4, '102002', 2, 0);
INSERT INTO t_menu VALUES (13, NULL, '角色更新', 0, NULL, 4, '102003', 2, 0);
INSERT INTO t_menu VALUES (14, NULL, '角色删除', 0, NULL, 4, '102004', 2, 0);
INSERT INTO t_menu VALUES (15, NULL, '角色授权', 0, NULL, 4, '102005', 2, 0);
INSERT INTO t_menu VALUES (16, 'meu-7', '菜单管理', 0, '', 2, '1030', 1, 0);
INSERT INTO t_menu VALUES (18, NULL, '用户管理', NULL, NULL, 1, '66', 0, 1);

-- 报溢单表（t_overflow_list）数据
INSERT INTO t_overflow_list VALUES (3, TO_DATE('2017-10-27 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'BY201710270001', 'dd', 1);
INSERT INTO t_overflow_list VALUES (4, TO_DATE('2017-10-27 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'BY201710270002', 'ccc', 1);
INSERT INTO t_overflow_list VALUES (5, TO_DATE('2021-03-04 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'BY202103040001', '', 1);
INSERT INTO t_overflow_list VALUES (10, TO_DATE('2022-01-22 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'BY202201220001', '', 1);
INSERT INTO t_overflow_list VALUES (11, TO_DATE('2022-01-22 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'BY202201220002', '', 1);
INSERT INTO t_overflow_list VALUES (12, TO_DATE('2022-01-22 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'BY202201220003', '', 1);

-- 报溢单商品表（t_overflow_list_goods）数据
INSERT INTO t_overflow_list_goods VALUES (4, '0002', 'Note8', '华为荣耀Note8', 2, 2220, 4440, '台', 3, 16, 2);
INSERT INTO t_overflow_list_goods VALUES (5, '0006', '300g装', '冰糖金桔干', 3, 5, 15, '盒', 3, 11, 14);
INSERT INTO t_overflow_list_goods VALUES (6, '0004', '2斤装', '新疆红枣', 2, 13, 26, '袋', 4, 10, 12);
INSERT INTO t_overflow_list_goods VALUES (7, '0006', '300g装', '冰糖金桔干', 3, 5, 15, '盒', 4, 11, 14);
INSERT INTO t_overflow_list_goods VALUES (8, '0002', 'Note8', '华为荣耀Note8', 20, 2220, 44400, '台', 5, 16, 2);
INSERT INTO t_overflow_list_goods VALUES (9, '0002', 'Note8', '华为荣耀Note8', 4, 2220, 8880, '台', 10, 16, 2);
INSERT INTO t_overflow_list_goods VALUES (10, '0001', '红色装', '陶华碧老干妈香辣脆油辣椒', 2, 8.5, 17, '瓶', 12, 10, 1);

-- 进货单（t_purchase_list）数据
INSERT INTO t_purchase_list VALUES (25, 73299, 73299, TO_DATE('2017-10-27 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'cc', 1, 'JH201710270001', 2, 1);
INSERT INTO t_purchase_list VALUES (26, 69099, 69099, TO_DATE('2017-10-28 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'cc', 1, 'JH201710280001', 2, 1);
INSERT INTO t_purchase_list VALUES (28, 17, 17, TO_DATE('2017-10-31 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'cc', 1, 'JH201710310001', 5, 1);
INSERT INTO t_purchase_list VALUES (29, 463, 463, TO_DATE('2022-01-19 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'cc', 1, 'JH201711030001', 1, 1);
INSERT INTO t_purchase_list VALUES (30, 1240, 1240, TO_DATE('2017-11-03 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'cc', 1, 'JH201711030002', 1, 1);
INSERT INTO t_purchase_list VALUES (41, 11185, 11185, TO_DATE('2021-03-02 00:00:00','YYYY-MM-DD HH24:MI:SS'), '', 1, 'JH202103020001', 1, 1);
INSERT INTO t_purchase_list VALUES (42, 170, 170, TO_DATE('2021-03-05 00:00:00','YYYY-MM-DD HH24:MI:SS'), '', 1, 'JH202103050001', 1, 1);
INSERT INTO t_purchase_list VALUES (56, 17, 17, TO_DATE('2022-01-21 00:00:00','YYYY-MM-DD HH24:MI:SS'), '', 1, 'JH202201210001', 3, 1);
INSERT INTO t_purchase_list VALUES (70, 25.5, 25.5, TO_DATE('2022-01-21 00:00:00','YYYY-MM-DD HH24:MI:SS'), '', 1, 'JH202201210002', 2, 1);
INSERT INTO t_purchase_list VALUES (72, 56, 56, TO_DATE('2022-03-12 00:00:00','YYYY-MM-DD HH24:MI:SS'), '', 1, 'JH202203110001', 3, 1);

-- 进货单商品表（t_purchase_list_goods）数据
INSERT INTO t_purchase_list_goods VALUES (35, '0002', 'Note8', '华为荣耀Note8', 33, 2220, 73260, '台', 25, 16, 2);
INSERT INTO t_purchase_list_goods VALUES (36, '0004', '2斤装', '新疆红枣', 3, 13, 39, '袋', 25, 10, 12);
INSERT INTO t_purchase_list_goods VALUES (37, '0003', '500g装', '野生东北黑木耳', 3000, 23, 69000, '袋', 26, 11, 11);
INSERT INTO t_purchase_list_goods VALUES (38, '0007', '500g装', '吉利人家牛肉味蛋糕', 22, 4.5, 99, '袋', 26, 11, 15);
INSERT INTO t_purchase_list_goods VALUES (41, '0001', '红色装', '陶华碧老干妈香辣脆油辣椒', 2, 8.5, 17, '瓶', 28, 10, 1);
INSERT INTO t_purchase_list_goods VALUES (42, '0001', '红色装', '陶华碧老干妈香辣脆油辣椒', 4, 8.5, 34, '瓶', 29, 10, 1);
INSERT INTO t_purchase_list_goods VALUES (43, '0004', '2斤装', '新疆红枣', 33, 13, 429, '袋', 29, 10, 12);
INSERT INTO t_purchase_list_goods VALUES (44, '0001', '红色装', '陶华碧老干妈香辣脆油辣椒', 100, 8.5, 850, '瓶', 30, 10, 1);
INSERT INTO t_purchase_list_goods VALUES (45, '0004', '2斤装', '新疆红枣', 30, 13, 390, '袋', 30, 10, 12);
INSERT INTO t_purchase_list_goods VALUES (46, '0015', 'X', ' iPhone X', 30, 0, 0, '台', 30, 16, 24);
INSERT INTO t_purchase_list_goods VALUES (56, '0001', '红色装', '陶华碧老干妈香辣脆油辣椒', 10, 8.5, 85, '瓶', 41, 10, 1);
INSERT INTO t_purchase_list_goods VALUES (57, '0002', 'Note8', '华为荣耀Note8', 5, 2220, 11100, '台', 41, 16, 2);
INSERT INTO t_purchase_list_goods VALUES (58, '0005', '散装500克', '麦片燕麦巧克力', 20, 8.5, 170, '袋', 42, 11, 13);
INSERT INTO t_purchase_list_goods VALUES (61, '0001', '红色装', '陶华碧老干妈香辣脆油辣椒', 2, 8.5, 17, '瓶', 56, 10, 1);
INSERT INTO t_purchase_list_goods VALUES (64, '0001', '红色装', '陶华碧老干妈香辣脆油辣椒', 3, 8.5, 25.5, '瓶', 70, 10, 1);
INSERT INTO t_purchase_list_goods VALUES (66, '0001', '红色装', '陶华碧老干妈香辣脆油辣椒', 2, 8.5, 17, '瓶', 72, 10, 1);
INSERT INTO t_purchase_list_goods VALUES (67, '0004', '2斤装', '新疆红枣', 3, 13, 39, '袋', 72, 10, 12);

-- 退货单表（t_return_list）数据
INSERT INTO t_return_list VALUES (4, 4464, 4464, 'cc', TO_DATE('2017-10-27 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'TH201710270001', 1, 2, 1);
INSERT INTO t_return_list VALUES (5, 4440, 4440, 'cc', TO_DATE('2017-11-03 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'TH201711030001', 1, 2, 1);
INSERT INTO t_return_list VALUES (7, 85, 85, '', TO_DATE('2021-03-03 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'TH202103030001', 1, 1, 1);
INSERT INTO t_return_list VALUES (8, 230, 230, '', TO_DATE('2021-03-03 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'TH202103030002', 1, 1, 1);

-- 退货单商品表（t_return_list_goods）数据
INSERT INTO t_return_list_goods VALUES (7, '0002', 'Note8', '华为荣耀Note8', 2, 2220, 4440, '台', 4, 16, 2);
INSERT INTO t_return_list_goods VALUES (8, '0005', '散装500克', '麦片燕麦巧克力', 3, 8, 24, '袋', 4, 11, 13);
INSERT INTO t_return_list_goods VALUES (9, '0002', 'Note8', '华为荣耀Note8', 2, 2220, 4440, '台', 5, 16, 2);
INSERT INTO t_return_list_goods VALUES (10, '0015', 'X', ' iPhone X', 3, 0, 0, '台', 5, 16, 24);
INSERT INTO t_return_list_goods VALUES (12, '0001', '红色装', '陶华碧老干妈香辣脆油辣椒', 10, 8.5, 85, '瓶', 7, 10, 1);
INSERT INTO t_return_list_goods VALUES (13, '0003', '500g装', '野生东北黑木耳', 10, 23, 230, '袋', 8, 11, 11);

-- 角色表（t_role）数据
INSERT INTO t_role VALUES (1, '系统管理员 最高权限', '管理员', NULL, 0);
INSERT INTO t_role VALUES (2, '主管', '主管', NULL, 0);
INSERT INTO t_role VALUES (4, '采购员', '采购员', NULL, 0);
INSERT INTO t_role VALUES (5, '销售经理', '销售经理', '', 0);
INSERT INTO t_role VALUES (7, '仓库管理员', '仓库管理员', NULL, 0);
INSERT INTO t_role VALUES (9, '总经理', '总经理', NULL, 1);
INSERT INTO t_role VALUES (10, 'test', '管理员02', '', 1);

-- 角色菜单表（t_role_menu）数据
INSERT INTO t_role_menu VALUES (134, 1, 1);
INSERT INTO t_role_menu VALUES (135, 2, 1);
INSERT INTO t_role_menu VALUES (136, 3, 1);
INSERT INTO t_role_menu VALUES (137, 7, 1);
INSERT INTO t_role_menu VALUES (138, 8, 1);
INSERT INTO t_role_menu VALUES (139, 9, 1);
INSERT INTO t_role_menu VALUES (140, 10, 1);
INSERT INTO t_role_menu VALUES (141, 4, 1);
INSERT INTO t_role_menu VALUES (142, 11, 1);
INSERT INTO t_role_menu VALUES (143, 12, 1);
INSERT INTO t_role_menu VALUES (144, 13, 1);
INSERT INTO t_role_menu VALUES (145, 14, 1);
INSERT INTO t_role_menu VALUES (146, 15, 1);
INSERT INTO t_role_menu VALUES (147, 5, 1);
INSERT INTO t_role_menu VALUES (148, 6, 1);
INSERT INTO t_role_menu VALUES (149, 1, 2);
INSERT INTO t_role_menu VALUES (150, 2, 2);
INSERT INTO t_role_menu VALUES (151, 5, 2);
INSERT INTO t_role_menu VALUES (152, 16, 1);

-- 销售单表（t_sale_list）数据
INSERT INTO t_sale_list VALUES (4, 5060, 5060, 'cc', TO_DATE('2017-01-27 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'XS201701270001', 1, 1, 2);
INSERT INTO t_sale_list VALUES (6, 4889, 4889, 'dd', TO_DATE('2017-02-28 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'XS201702280002', 1, 1, 2);
INSERT INTO t_sale_list VALUES (7, 4400, 4400, 'cccc', TO_DATE('2017-03-30 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'XS201703300001', 1, 1, 2);
INSERT INTO t_sale_list VALUES (8, 860, 860, 'cc', TO_DATE('2017-04-30 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'XS201704300002', 1, 1, 2);
INSERT INTO t_sale_list VALUES (11, 83, 83, 'ccc', TO_DATE('2017-05-01 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'XS201705100003', 1, 1, 2);
INSERT INTO t_sale_list VALUES (12, 6626, 6626, 'cccc', TO_DATE('2017-06-03 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'XS201706300001', 1, 1, 2);
INSERT INTO t_sale_list VALUES (13, 76, 76, 'cc', TO_DATE('2017-06-03 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'XS201706300002', 1, 1, 1);
INSERT INTO t_sale_list VALUES (14, 127, 127, 'cc', TO_DATE('2017-07-03 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'XS201707300003', 2, 1, 2);
INSERT INTO t_sale_list VALUES (15, 1579.5, 1579.5, 'cc', TO_DATE('2017-08-03 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'XS201708300004', 1, 1, 2);
INSERT INTO t_sale_list VALUES (20, 10, 10, 'cc', TO_DATE('2017-10-31 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'XS201710310009', 1, 1, 1);
INSERT INTO t_sale_list VALUES (21, 202, 202, 'cc', TO_DATE('2017-11-01 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'XS201711010010', 1, 1, 2);
INSERT INTO t_sale_list VALUES (22, 3650, 3650, '11', TO_DATE('2017-11-02 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'XS201711020011', 1, 1, 2);
INSERT INTO t_sale_list VALUES (23, 20, 20, 'cc', TO_DATE('2017-11-03 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'XS201711030012', 1, 1, 1);
INSERT INTO t_sale_list VALUES (24, 59, 59, 'cc', TO_DATE('2016-12-03 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'XS201712030013', 1, 1, 2);
INSERT INTO t_sale_list VALUES (25, 146, 146, 'cc', TO_DATE('2016-11-03 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'XS201711030014', 1, 1, 1);
INSERT INTO t_sale_list VALUES (26, 215, 215, '', TO_DATE('2021-03-03 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'XS202103030001', 1, 1, 1);
INSERT INTO t_sale_list VALUES (28, 1, 666, '', TO_DATE('2022-01-21 00:00:00','YYYY-MM-DD HH24:MI:SS'), 'XS202201210001', 1, 1, 1);

-- 销售单商品表（t_sale_list_goods）数据
INSERT INTO t_sale_list_goods VALUES (7, '0002', 'Note8', '华为荣耀Note8', 2, 2200, 4400, '台', 4, 16, 2);
INSERT INTO t_sale_list_goods VALUES (8, '0010', '250g装', '劲仔小鱼干', 33, 20, 660, '袋', 4, 11, 18);
INSERT INTO t_sale_list_goods VALUES (11, '0003', '500g装', '野生东北黑木耳', 100, 38, 3800, '袋', 6, 11, 11);
INSERT INTO t_sale_list_goods VALUES (12, '0009', '240g装', '休闲零食坚果特产精品干果无漂白大个开心果', 33, 33, 1089, '袋', 6, 11, 17);
INSERT INTO t_sale_list_goods VALUES (13, '0002', 'Note8', '华为荣耀Note8', 2, 2200, 4400, '台', 7, 16, 2);
INSERT INTO t_sale_list_goods VALUES (14, '0003', '500g装', '野生东北黑木耳', 22, 38, 836, '袋', 8, 11, 11);
INSERT INTO t_sale_list_goods VALUES (15, '0014', '250g装', '美国青豆原味 蒜香', 3, 8, 24, '袋', 8, 11, 22);
INSERT INTO t_sale_list_goods VALUES (20, '0003', '500g装', '野生东北黑木耳', 1, 38, 38, '袋', 11, 11, 11);
INSERT INTO t_sale_list_goods VALUES (21, '0005', '散装500克', '麦片燕麦巧克力', 3, 15, 45, '袋', 11, 11, 13);
INSERT INTO t_sale_list_goods VALUES (22, '0002', 'Note8', '华为荣耀Note8', 3, 2200, 6600, '台', 12, 16, 2);
INSERT INTO t_sale_list_goods VALUES (23, '0006', '300g装', '冰糖金桔干', 2, 13, 26, '盒', 12, 11, 14);
INSERT INTO t_sale_list_goods VALUES (24, '0003', '500g装', '野生东北黑木耳', 2, 38, 76, '袋', 13, 11, 11);
INSERT INTO t_sale_list_goods VALUES (25, '0004', '2斤装', '新疆红枣', 3, 25, 75, '袋', 14, 10, 12);
INSERT INTO t_sale_list_goods VALUES (26, '0006', '300g装', '冰糖金桔干', 4, 13, 52, '盒', 14, 11, 14);
INSERT INTO t_sale_list_goods VALUES (27, '0001', '红色装', '陶华碧老干妈香辣脆油辣椒', 33, 8.5, 280.5, '瓶', 15, 10, 1);
INSERT INTO t_sale_list_goods VALUES (28, '0018', 'IXUS 285 HS', 'Canon/佳能 IXUS 285 HS 数码相机 2020万像素高清拍摄', 1, 1299, 1299, '台', 15, 15, 27);
INSERT INTO t_sale_list_goods VALUES (36, '0007', '500g装', '吉利人家牛肉味蛋糕', 1, 10, 10, '袋', 20, 11, 15);
INSERT INTO t_sale_list_goods VALUES (37, '0003', '500g装', '野生东北黑木耳', 2, 38, 76, '袋', 21, 11, 11);
INSERT INTO t_sale_list_goods VALUES (38, '0007', '500g装', '吉利人家牛肉味蛋糕', 2, 10, 20, '袋', 21, 11, 15);
INSERT INTO t_sale_list_goods VALUES (39, '0009', '240g装', '休闲零食坚果特产精品干果无漂白大个开心果', 2, 33, 66, '袋', 21, 11, 17);
INSERT INTO t_sale_list_goods VALUES (40, '0010', '250g装', '劲仔小鱼干', 2, 20, 40, '袋', 21, 11, 18);
INSERT INTO t_sale_list_goods VALUES (41, '0017', 'ILCE-A6000L', 'Sony/索尼 ILCE-A6000L WIFI微单数码相机高清单电', 1, 3650, 3650, '台', 22, 15, 26);
INSERT INTO t_sale_list_goods VALUES (42, '0010', '250g装', '劲仔小鱼干', 1, 20, 20, '袋', 23, 11, 18);
INSERT INTO t_sale_list_goods VALUES (43, '0009', '240g装', '休闲零食坚果特产精品干果无漂白大个开心果', 1, 33, 33, '袋', 24, 11, 17);
INSERT INTO t_sale_list_goods VALUES (44, '0006', '300g装', '冰糖金桔干', 2, 13, 26, '盒', 24, 11, 14);
INSERT INTO t_sale_list_goods VALUES (45, '0009', '240g装', '休闲零食坚果特产精品干果无漂白大个开心果', 2, 33, 66, '袋', 25, 11, 17);
INSERT INTO t_sale_list_goods VALUES (46, '0014', '250g装', '美国青豆原味 蒜香', 10, 8, 80, '袋', 25, 11, 22);
INSERT INTO t_sale_list_goods VALUES (47, '0001', '红色装', '陶华碧老干妈香辣脆油辣椒', 10, 8.5, 85, '瓶', 26, 10, 1);
INSERT INTO t_sale_list_goods VALUES (48, '0004', '2斤装', '新疆红枣', 10, 13, 130, '袋', 26, 10, 12);

-- 供应商表（t_supplier）数据
INSERT INTO t_supplier VALUES (1, '上海市金山区张堰镇松金公路2072号6607室', '小张', '上海福桂食品有限公司', '0773-7217175', '失信供应商', 0);
INSERT INTO t_supplier VALUES (2, '安徽省合肥市肥西县桃花工业园合派路', '小王', '安徽麦堡食品工业有限公司', '0773-7217275', NULL, 0);
INSERT INTO t_supplier VALUES (3, '晋江市罗山后林西区41号', '小李', '福建省晋江市罗山惠康食品有限公司', '1273-1217175', '优质供应商', 0);
INSERT INTO t_supplier VALUES (4, '南京市江宁区科学园竹山路565号1幢', '小丽', '南京含羞草食品有限公司', '2121-7217175', NULL, 0);
INSERT INTO t_supplier VALUES (5, '南京市高淳县阳江镇新桥村下桥278号', '王大狗', '南京禾乃美工贸有限公司', '2133-7217125', NULL, 0);
INSERT INTO t_supplier VALUES (6, '开平市水口镇东埠路６号', '小七', '开平广合腐乳有限公司', '3332-7217175', '2', 0);
INSERT INTO t_supplier VALUES (7, '汕头市跃进路２３号利鸿基中心大厦写字楼２座', '刘钩子', '汕头市金茂食品有限公司', '0723-7232175', NULL, 0);
INSERT INTO t_supplier VALUES (8, '南京市溧水区经济开发区', '七枷社', '南京喜之郎食品有限公司', '1773-7217175', NULL, 0);
INSERT INTO t_supplier VALUES (9, '深圳市罗湖区翠竹北路中深石化区厂房B栋6楼', '小蔡', '深圳昌信实业有限公司', '1773-7217175', NULL, 0);
INSERT INTO t_supplier VALUES (10, '南京市下关区金陵小区6村27-2-203室', '小路', '南京市下关区红鹰调味品商行', '2132-7217175', NULL, 0);
INSERT INTO t_supplier VALUES (11, '荔浦县荔塔路１６－３６号', '亲亲', '桂林阜康食品工业有限公司', '2123-7217175', NULL, 0);
INSERT INTO t_supplier VALUES (12, '南京鼓楼区世纪大楼123号', '小二', '南京大王科技', '0112-1426789', '123', 1);
INSERT INTO t_supplier VALUES (13, '南京将军路800号', '小吴', '南京大陆食品公司', '1243-2135487', 'cc', 1);
INSERT INTO t_supplier VALUES (14, '32423', 'test', 'test', '33', NULL, 1);
INSERT INTO t_supplier VALUES (15, '杭州滨江', 'test', '男士马甲', '33', NULL, 1);

-- 用户表（t_user）数据
INSERT INTO t_user VALUES (1, 'admin', '$2a$10$Bl.B94Xj212z9b8KPEATYOCxUZmViFnSwmsLpBpZq8/05Tj09mNue', '管理员', 'admin', 'admin', 0);
INSERT INTO t_user VALUES (2, '帅哥', '$2a$10$Bl.B94Xj212z9b8KPEATYOCxUZmViFnSwmsLpBpZq8/05Tj09mNue', '吴彦祖', 'wuyanzu', '', 0);
INSERT INTO t_user VALUES (3, '销售经理', '$2a$10$Bl.B94Xj212z9b8KPEATYOCxUZmViFnSwmsLpBpZq8/05Tj09mNue', '玛丽', 'marry', '66', 0);
INSERT INTO t_user VALUES (15, 'test', '$2a$10$Bl.B94Xj212z9b8KPEATYOCxUZmViFnSwmsLpBpZq8/05Tj09mNue', '测试', 'test', NULL, 0);
INSERT INTO t_user VALUES (16, '本人', '$2a$10$LKTvZEl31ek0NcPo0beaYelVORN.ohSHLA0llM4Q6o6Rt.Ep0EV/S', '吴彦祖', 'hty', NULL, 0);
INSERT INTO t_user VALUES (17, '老弟', '$2a$10$/xUlWKf1eHZs.55mQ7w9NeqbQxZoh4UB5q02THnYTzDiZjqfszy5C', '宋馨', 'song', NULL, 0);

-- 用户角色表（t_user_role）数据
INSERT INTO t_user_role VALUES (42, 1, 1);
INSERT INTO t_user_role VALUES (44, 2, 2);
INSERT INTO t_user_role VALUES (45, 1, 16);
INSERT INTO t_user_role VALUES (46, 1, 17);

-- ====================== 外键约束 ======================
ALTER TABLE T_CUSTOMER_RETURN_LIST ADD CONSTRAINT FK_TCRL_USER FOREIGN KEY (USER_ID) REFERENCES T_USER(ID);
ALTER TABLE T_CUSTOMER_RETURN_LIST ADD CONSTRAINT FK_TCRL_CUSTOMER FOREIGN KEY (CUSTOMER_ID) REFERENCES T_CUSTOMER(ID);

ALTER TABLE T_CUSTOMER_RETURN_LIST_GOODS ADD CONSTRAINT FK_TCRLG_LIST FOREIGN KEY (CUSTOMER_RETURN_LIST_ID) REFERENCES T_CUSTOMER_RETURN_LIST(ID);
ALTER TABLE T_CUSTOMER_RETURN_LIST_GOODS ADD CONSTRAINT FK_TCRLG_TYPE FOREIGN KEY (TYPE_ID) REFERENCES T_GOODS_TYPE(ID);

ALTER TABLE T_DAMAGE_LIST ADD CONSTRAINT FK_TDL_USER FOREIGN KEY (USER_ID) REFERENCES T_USER(ID);
ALTER TABLE T_DAMAGE_LIST_GOODS ADD CONSTRAINT FK_TDL_GOODS_DLIST FOREIGN KEY (DAMAGE_LIST_ID) REFERENCES T_DAMAGE_LIST(ID);
ALTER TABLE T_DAMAGE_LIST_GOODS ADD CONSTRAINT FK_TDL_GTYPE FOREIGN KEY (TYPE_ID) REFERENCES T_GOODS_TYPE(ID);

ALTER TABLE T_GOODS ADD CONSTRAINT FK_GOODS_TYPE FOREIGN KEY (TYPE_ID) REFERENCES T_GOODS_TYPE(ID);
ALTER TABLE T_LOG ADD CONSTRAINT FK_LOG_USER FOREIGN KEY (USER_ID) REFERENCES T_USER(ID);

ALTER TABLE T_OVERFLOW_LIST ADD CONSTRAINT FK_OL_USER FOREIGN KEY (USER_ID) REFERENCES T_USER(ID);
ALTER TABLE T_OVERFLOW_LIST_GOODS ADD CONSTRAINT FK_OL_GOODS_OLIST FOREIGN KEY (OVERFLOW_LIST_ID) REFERENCES T_OVERFLOW_LIST(ID);
ALTER TABLE T_OVERFLOW_LIST_GOODS ADD CONSTRAINT FK_OL_GTYPE FOREIGN KEY (TYPE_ID) REFERENCES T_GOODS_TYPE(ID);

ALTER TABLE T_PURCHASE_LIST ADD CONSTRAINT FK_PL_SUPPLIER FOREIGN KEY (SUPPLIER_ID) REFERENCES T_SUPPLIER(ID);
ALTER TABLE T_PURCHASE_LIST ADD CONSTRAINT FK_PL_USER FOREIGN KEY (USER_ID) REFERENCES T_USER(ID);
ALTER TABLE T_PURCHASE_LIST_GOODS ADD CONSTRAINT FK_PL_GLIST FOREIGN KEY (PURCHASE_LIST_ID) REFERENCES T_PURCHASE_LIST(ID);
ALTER TABLE T_PURCHASE_LIST_GOODS ADD CONSTRAINT FK_PL_GTYPE FOREIGN KEY (TYPE_ID) REFERENCES T_GOODS_TYPE(ID);

ALTER TABLE T_RETURN_LIST ADD CONSTRAINT FK_RL_SUPPLIER FOREIGN KEY (SUPPLIER_ID) REFERENCES T_SUPPLIER(ID);
ALTER TABLE T_RETURN_LIST ADD CONSTRAINT FK_RL_USER FOREIGN KEY (USER_ID) REFERENCES T_USER(ID);
ALTER TABLE T_RETURN_LIST_GOODS ADD CONSTRAINT FK_RL_GLIST FOREIGN KEY (RETURN_LIST_ID) REFERENCES T_RETURN_LIST(ID);
ALTER TABLE T_RETURN_LIST_GOODS ADD CONSTRAINT FK_RL_GTYPE FOREIGN KEY (TYPE_ID) REFERENCES T_GOODS_TYPE(ID);

ALTER TABLE T_SALE_LIST ADD CONSTRAINT FK_SL_USER FOREIGN KEY (USER_ID) REFERENCES T_USER(ID);
ALTER TABLE T_SALE_LIST ADD CONSTRAINT FK_SL_CUSTOMER FOREIGN KEY (CUSTOMER_ID) REFERENCES T_CUSTOMER(ID);
ALTER TABLE T_SALE_LIST_GOODS ADD CONSTRAINT FK_SL_GLIST FOREIGN KEY (SALE_LIST_ID) REFERENCES T_SALE_LIST(ID);
ALTER TABLE T_SALE_LIST_GOODS ADD CONSTRAINT FK_SL_GTYPE FOREIGN KEY (TYPE_ID) REFERENCES T_GOODS_TYPE(ID);

ALTER TABLE T_ROLE_MENU ADD CONSTRAINT FK_RM_ROLE FOREIGN KEY (ROLE_ID) REFERENCES T_ROLE(ID);
ALTER TABLE T_ROLE_MENU ADD CONSTRAINT FK_RM_MENU FOREIGN KEY (MENU_ID) REFERENCES T_MENU(ID);

ALTER TABLE T_USER_ROLE ADD CONSTRAINT FK_UR_USER FOREIGN KEY (USER_ID) REFERENCES T_USER(ID);
ALTER TABLE T_USER_ROLE ADD CONSTRAINT FK_UR_ROLE FOREIGN KEY (ROLE_ID) REFERENCES T_ROLE(ID);
COMMIT;

-- ====================== 基础测试数据 ======================
-- 记住我登录
INSERT INTO PERSISTENT_LOGINS (USERNAME,SERIES,TOKEN,LAST_USED)
VALUES ('admin','2eYiRK+p0882pdtogwEYqQ==','biRZCWsBdUSPbJ8K5siEYA==',TO_TIMESTAMP('2022-03-12 10:51:53','YYYY-MM-DD HH24:MI:SS'));

-- 用户表
INSERT INTO T_USER(ID,BZ,PASSWORD,TRUE_NAME,USER_NAME,REMARKS,IS_DEL)
VALUES (1,'admin','$2a$10$Bl.B94Xj212z9b8KPEATYOCxUZmViFnSwmsLpBpZq8/05Tj09mNue','管理员','admin','admin',0);
INSERT INTO T_USER(ID,BZ,PASSWORD,TRUE_NAME,USER_NAME,REMARKS,IS_DEL)
VALUES (2,'帅哥','$2a$10$Bl.B94Xj212z9b8KPEATYOCxUZmViFnSwmsLpBpZq8/05Tj09mNue','吴彦祖','wuyanzu','',0);
INSERT INTO T_USER(ID,BZ,PASSWORD,TRUE_NAME,USER_NAME,REMARKS,IS_DEL)
VALUES (3,'销售经理','$2a$10$Bl.B94Xj212z9b8KPEATYOCxUZmViFnSwmsLpBpZq8/05Tj09mNue','玛丽','marry','66',0);
INSERT INTO T_USER(ID,BZ,PASSWORD,TRUE_NAME,USER_NAME,REMARKS,IS_DEL)
VALUES (15,'test','$2a$10$Bl.B94Xj212z9b8KPEATYOCxUZmViFnSwmsLpBpZq8/05Tj09mNue','测试','test',NULL,0);
INSERT INTO T_USER(ID,BZ,PASSWORD,TRUE_NAME,USER_NAME,REMARKS,IS_DEL)
VALUES (16,'本人','$2a$10$LKTvZEl31ek0NcPo0beaYelVORN.ohSHLA0llM4Q6o6Rt.Ep0EV/S','吴彦祖','hty',NULL,0);
INSERT INTO T_USER(ID,BZ,PASSWORD,TRUE_NAME,USER_NAME,REMARKS,IS_DEL)
VALUES (17,'老弟','$2a$10$/xUlWKf1eHZs.55mQ7w9NeqbQxZoh4UB5q02THnYTzDiZjqfszy5C','宋馨','song',NULL,0);

-- 客户表
INSERT INTO T_CUSTOMER(ID,ADDRESS,CONTACT,NAME,PHONE,REMARKS,IS_DEL)
VALUES (1,'福州新弯曲5号','小李子','福州艾玛超市','2132-2321342','',0);
INSERT INTO T_CUSTOMER(ID,ADDRESS,CONTACT,NAME,PHONE,REMARKS,IS_DEL)
VALUES (2,'天津兴达大街888号','小张','天津王大连锁酒店','23432222311','优质客户',0);
INSERT INTO T_CUSTOMER(ID,ADDRESS,CONTACT,NAME,PHONE,REMARKS,IS_DEL)
VALUES (3,'大凉山妥洛村','小爱','大凉山希望小学','233243211','照顾客户2',1);
INSERT INTO T_CUSTOMER(ID,ADDRESS,CONTACT,NAME,PHONE,REMARKS,IS_DEL)
VALUES (4,'南通通州新金路888号','王二小','南通通州综艺集团','1832132321','',1);
INSERT INTO T_CUSTOMER(ID,ADDRESS,CONTACT,NAME,PHONE,REMARKS,IS_DEL)
VALUES (5,'12321','test','test','33',NULL,1);
INSERT INTO T_CUSTOMER(ID,ADDRESS,CONTACT,NAME,PHONE,REMARKS,IS_DEL)
VALUES (6,'黑龙江省绥化市','吴彦祖','黄天禹','1',NULL,1);
INSERT INTO T_CUSTOMER(ID,ADDRESS,CONTACT,NAME,PHONE,REMARKS,IS_DEL)
VALUES (7,'成华大道','吴先生','吴彦祖超市','562119139',NULL,0);
INSERT INTO T_CUSTOMER(ID,ADDRESS,CONTACT,NAME,PHONE,REMARKS,IS_DEL)
VALUES (8,'小鸡岛','柒','五六七五星级旅店','36287738',NULL,0);
INSERT INTO T_CUSTOMER(ID,ADDRESS,CONTACT,NAME,PHONE,REMARKS,IS_DEL)
VALUES (9,'我也不知道啊','皮卡丘','可达鸭有限公司','4008208820',NULL,0);



COMMIT;
DBMS_OUTPUT.PUT_LINE('Oracle脚本执行完成，无语法错误！');
/
