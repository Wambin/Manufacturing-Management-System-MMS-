<template>
  <div class="page-container">
    <el-card>
      <div slot="header" class="card-header">
        <span>发货详情</span>
      </div>

      <div v-if="deliveryInfo" class="delivery-detail">
        <!-- 发货基本信息 -->
        <el-descriptions :column="3" border>
          <el-descriptions-item label="发货单号">{{ deliveryInfo.deliveryNo }}</el-descriptions-item>
          <el-descriptions-item label="发货日期">{{ deliveryInfo.deliveryDate }}</el-descriptions-item>
          <el-descriptions-item label="快递单号">{{ deliveryInfo.trackingNo }}</el-descriptions-item>
          <el-descriptions-item label="联系人">{{ deliveryInfo.contactPerson }}</el-descriptions-item>
          <el-descriptions-item label="联系电话">{{ deliveryInfo.contactPhone }}</el-descriptions-item>
          <el-descriptions-item label="发货地址">{{ deliveryInfo.deliveryAddress }}</el-descriptions-item>
          <el-descriptions-item label="收货人">{{ deliveryInfo.receiverName }}</el-descriptions-item>
          <el-descriptions-item label="收货电话">{{ deliveryInfo.receiverPhone }}</el-descriptions-item>
          <el-descriptions-item label="收货地址">{{ deliveryInfo.receiverAddress }}</el-descriptions-item>
        </el-descriptions>

        <!-- 订单信息 -->
        <el-divider content-position="left">订单信息</el-divider>
        <div v-if="orderInfo" class="order-info">
          <el-descriptions :column="4" border>
            <el-descriptions-item label="订单号">{{ orderInfo.orderNo }}</el-descriptions-item>
            <el-descriptions-item label="合同号">{{ orderInfo.contractNo || '-' }}</el-descriptions-item>
            <el-descriptions-item label="交货日期">{{ orderInfo.deliveryDate }}</el-descriptions-item>
            <el-descriptions-item label="订单总数">{{ orderInfo.totalQuantity }}</el-descriptions-item>
          </el-descriptions>
        </div>

        <!-- 物料清单 -->
        <el-divider content-position="left">物料清单</el-divider>
        <el-table :data="materials" border style="margin-bottom: 20px">
          <el-table-column prop="materialCode" label="物料编码" width="120"></el-table-column>
          <el-table-column prop="materialName" label="物料名称" width="150"></el-table-column>
          <el-table-column prop="specification" label="规格" width="120"></el-table-column>
          <el-table-column prop="quantity" label="数量" width="80"></el-table-column>
          <el-table-column prop="unit" label="单位" width="80"></el-table-column>
        </el-table>

        <!-- 物流信息 -->
        <el-divider content-position="left">物流信息</el-divider>
        <div class="logistics-info">
          <el-form :model="deliveryInfo" label-width="100px">
            <el-form-item label="快递单号">
              <el-input v-model="deliveryInfo.trackingNo" disabled></el-input>
            </el-form-item>
            <el-form-item label="物流状态">
              <el-tag type="primary">{{ deliveryInfo.status === 1 ? '已收货' : '运输中' }}</el-tag>
            </el-form-item>
            <el-form-item label="发货备注">
              <el-input v-model="deliveryInfo.remark" type="textarea" :rows="3" disabled></el-input>
            </el-form-item>
          </el-form>
        </div>

        <!-- 发货单和快递单照片 -->
        <el-divider content-position="left">上传文件</el-divider>
        <div class="upload-files" style="margin-top: 20px;">
          <!-- 发货单 -->
          <div style="margin-bottom: 20px; padding: 15px; border: 1px solid #e4e7ed; border-radius: 4px; background: #f9f9f9;">
            <h4 style="margin-top: 0; margin-bottom: 15px; font-size: 14px; font-weight: bold; color: #303133;">发货单</h4>
            <div style="text-align: center; padding: 20px;">
              <el-button v-if="deliveryInfo.deliveryNote" type="primary" size="medium" @click="viewFile(deliveryInfo.deliveryNote)">
                <i class="el-icon-document"></i> 查看发货单
              </el-button>
              <el-empty v-else description="暂无发货单" />
            </div>
          </div>

          <!-- 快递单照片 -->
          <div style="margin-bottom: 20px; padding: 15px; border: 1px solid #e4e7ed; border-radius: 4px; background: #f9f9f9;">
            <h4 style="margin-top: 0; margin-bottom: 15px; font-size: 14px; font-weight: bold; color: #303133;">快递单照片</h4>
            <div style="display: flex; justify-content: center; align-items: center; min-height: 200px; padding: 20px; border: 2px dashed #d9d9d9; border-radius: 4px; background: #ffffff;">
              <el-image 
                v-if="deliveryInfo.expressPhoto"
                :src="deliveryInfo.expressPhoto"
                fit="contain"
                style="max-width: 100%; max-height: 200px;"
                :preview-src-list="[deliveryInfo.expressPhoto]"
              >
                <div slot="error" class="image-slot">
                  <i class="el-icon-picture-outline"></i>
                  <div style="margin-top: 10px;">图片加载失败</div>
                </div>
              </el-image>
              <el-empty v-else description="暂无快递单照片" />
            </div>
          </div>
        </div>

        <!-- 操作按钮 -->
        <div class="action-buttons" style="margin-top: 20px; text-align: right">
          <el-button v-if="deliveryInfo.status === 0" type="primary" @click="handleConfirmReceive">确认收货</el-button>
          <el-button @click="handleBack">返回列表</el-button>
        </div>
      </div>
      <div v-else class="loading">
        <el-icon class="is-loading"><i class="el-icon-loading"></i></el-icon> 加载中...
      </div>
    </el-card>
  </div>
</template>

<script>
export default {
  name: 'DeliveryView',
  data() {
    return {
      deliveryInfo: null,
      orderInfo: null,
      materials: []
    }
  },
  mounted() {
    const id = this.$route.query.id
    if (id) {
      this.loadDeliveryData(id)
    }
  },
  methods: {
    loadDeliveryData(id) {
      this.$http.get(`/api/delivery/record/${id}`).then(res => {
        if (res.data.code === 200) {
          this.deliveryInfo = res.data.data
          this.loadOrderInfo(this.deliveryInfo.orderId)
        }
      })
    },
    loadOrderInfo(orderId) {
      this.$http.get(`/api/purchase/order/${orderId}`).then(res => {
        if (res.data.code === 200) {
          this.orderInfo = res.data.data
          // 从订单信息中获取物料信息
          this.materials = this.parseMaterials(this.orderInfo.materials)
        }
      })
    },
    parseMaterials(str) {
      if (!str) return []
      try {
        const arr = JSON.parse(str)
        return Array.isArray(arr) ? arr : []
      } catch {
        return []
      }
    },
    viewFile(fileUrl) {
      // 打开文件查看
      window.open(fileUrl, '_blank')
    },
    handleConfirmReceive() {
      this.$confirm('确定要确认收货吗？', '警告', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$http.put(`/api/delivery/record/${this.deliveryInfo.id}/receive`).then(res => {
          if (res.data.code === 200) {
            this.$message.success('确认收货成功')
            this.deliveryInfo.status = 1
          }
        })
      }).catch(() => {
        // 取消确认
      })
    },
    handleBack() {
      this.$router.push('/purchase/delivery/list')
    }
  }
}
</script>

<style scoped>
.page-container {
  padding: 20px;
}

.card-header {
  font-weight: bold;
}

.delivery-detail {
  margin-top: 20px;
}

.order-info {
  margin-bottom: 20px;
}

.loading {
  text-align: center;
  padding: 50px 0;
  color: #999;
}

.action-buttons {
  margin-top: 30px;
}
</style>