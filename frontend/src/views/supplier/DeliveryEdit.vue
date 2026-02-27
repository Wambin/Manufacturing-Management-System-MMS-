<template>
  <div class="page-container">
    <el-card>
      <div slot="header" class="card-header">
        <span>{{ isView ? '查看发货详情' : '填写发货信息' }}</span>
      </div>

      <div v-if="orderInfo" class="order-summary">
        <el-descriptions :column="4" border>
          <el-descriptions-item label="订单号">{{ orderInfo.orderNo }}</el-descriptions-item>
          <el-descriptions-item label="合同号">{{ orderInfo.contractNo || '-' }}</el-descriptions-item>
          <el-descriptions-item label="交货日期">{{ orderInfo.deliveryDate }}</el-descriptions-item>
          <el-descriptions-item label="订单总数">{{ orderInfo.totalQuantity }}</el-descriptions-item>
        </el-descriptions>
      </div>

      <el-divider content-position="left">发货信息</el-divider>

      <el-form :model="form" label-width="120px">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="发货日期">
              <el-date-picker v-model="form.deliveryDate" type="date" placeholder="选择日期" style="width: 100%" value-format="yyyy-MM-dd" :disabled="isView"></el-date-picker>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="快递单号">
              <el-input v-model="form.trackingNo" placeholder="请输入快递单号" :disabled="isView"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="发货地址">
              <el-input v-model="form.deliveryAddress" placeholder="请输入发货地址" :disabled="isView"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="联系人/电话">
              <el-input v-model="form.contactPerson" placeholder="联系人" style="width: 45%" :disabled="isView"></el-input>
              <el-input v-model="form.contactPhone" placeholder="电话" style="width: 45%; margin-left: 10px" :disabled="isView"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="8">
            <el-form-item label="收货人">
              <el-input v-model="form.receiverName" placeholder="收货人" :disabled="isView"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="收货人电话">
              <el-input v-model="form.receiverPhone" placeholder="收货人电话" :disabled="isView"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="收货地址">
              <el-input v-model="form.receiverAddress" placeholder="收货地址" :disabled="isView"></el-input>
            </el-form-item>
          </el-col>
        </el-row>

        <el-divider content-position="left">物料清单</el-divider>

        <el-table :data="materials" border style="margin-bottom: 20px">
          <el-table-column type="selection" width="55" v-if="!isView"></el-table-column>
          <el-table-column label="物料编码" width="120" prop="materialCode"></el-table-column>
          <el-table-column label="物料名称" width="150" prop="materialName"></el-table-column>
          <el-table-column label="单价" width="100" prop="price"></el-table-column>
          <el-table-column label="订单数量" width="100" prop="orderQuantity"></el-table-column>
          <el-table-column label="已发货" width="100" prop="shippedQuantity"></el-table-column>
          <el-table-column label="本次发货" width="120" v-if="!isView">
            <template slot-scope="scope">
              <el-input-number v-model="scope.row.currentQuantity" :min="1" :max="scope.row.orderQuantity - scope.row.shippedQuantity" size="small" style="width: 100%"></el-input-number>
            </template>
          </el-table-column>
          <el-table-column label="实物图" width="100" v-if="!isView">
            <template slot-scope="scope">
              <el-upload
                action="http://localhost:8080/api/upload"
                :show-file-list="false"
                :on-success="(res) => handleMaterialImageSuccess(res, scope.row)">
                <img v-if="scope.row.image" :src="scope.row.image" class="material-image">
                <i v-else class="el-icon-plus material-upload-icon"></i>
              </el-upload>
            </template>
          </el-table-column>
          <el-table-column label="备注" width="120">
            <template slot-scope="scope">
              <el-input v-model="scope.row.remark" placeholder="备注" size="small" :disabled="isView"></el-input>
            </template>
          </el-table-column>
        </el-table>

        <el-divider content-position="left">文件上传</el-divider>

        <el-form-item label="发货单" v-if="!isView">
          <el-upload
            action="http://localhost:8080/api/upload"
            :on-success="handleDeliveryNoteSuccess"
            :file-list="deliveryNoteList"
            :limit="1"
            :show-file-list="false">
            <el-button size="small" type="primary">上传发货单</el-button>
            <span v-if="form.deliveryNote" style="color: #67C23A; margin-left: 10px">✓ 已上传</span>
          </el-upload>
        </el-form-item>

        <el-form-item label="快递单照片" v-if="!isView">
          <el-upload
            action="http://localhost:8080/api/upload"
            :on-success="handleExpressPhotoSuccess"
            :file-list="expressPhotoList"
            :limit="1"
            list-type="picture-card"
            :show-file-list="true">
            <i class="el-icon-plus"></i>
          </el-upload>
        </el-form-item>

        <el-form-item label="备注">
          <el-input v-model="form.remark" type="textarea" :rows="3" placeholder="请输入备注" :disabled="isView"></el-input>
        </el-form-item>

        <el-form-item v-if="!isView">
          <el-button type="primary" @click="handleSubmit">提交发货</el-button>
          <el-button @click="handleCancel">取消</el-button>
        </el-form-item>
        <el-form-item v-else>
          <el-button @click="handleCancel">返回</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script>
export default {
  name: 'DeliveryEdit',
  data() {
    return {
      isView: false,
      orderId: null,
      orderInfo: null,
      form: {
        orderId: null,
        deliveryDate: '',
        trackingNo: '',
        deliveryAddress: '',
        contactPerson: '',
        contactPhone: '',
        receiverName: '',
        receiverPhone: '',
        receiverAddress: '',
        deliveryNote: '',
        expressPhoto: '',
        remark: ''
      },
      materials: [],
      deliveryNoteList: [],
      expressPhotoList: []
    }
  },
  mounted() {
    this.orderId = this.$route.query.orderId
    this.isView = this.$route.query.view === 'true'
    if (this.orderId) {
      this.loadOrder()
    }
  },
  methods: {
    loadOrder() {
      this.$http.get('/api/purchase/order/' + this.orderId).then(res => {
        if (res.data.code === 200) {
          this.orderInfo = res.data.data
          this.form.orderId = this.orderId
          this.form.deliveryDate = this.formatDate(new Date())
          this.materials = this.parseMaterials(this.orderInfo.materials)
        }
      })
    },
    parseMaterials(str) {
      if (!str) return []
      try {
        const arr = JSON.parse(str)
        return Array.isArray(arr) ? arr.map(m => ({
          ...m,
          orderQuantity: m.quantity || 0,
          shippedQuantity: 0,
          currentQuantity: 1,
          image: '',
          remark: ''
        })) : []
      } catch {
        return []
      }
    },
    formatDate(date) {
      const y = date.getFullYear()
      const m = String(date.getMonth() + 1).padStart(2, '0')
      const d = String(date.getDate()).padStart(2, '0')
      return `${y}-${m}-${d}`
    },
    handleDeliveryNoteSuccess(res) {
      if (res.code === 200) {
        this.form.deliveryNote = res.data.url
      }
    },
    handleExpressPhotoSuccess(res) {
      if (res.code === 200) {
        this.form.expressPhoto = res.data.url
      }
    },
    handleMaterialImageSuccess(res, row) {
      if (res.code === 200) {
        row.image = res.data.url
      }
    },
    handleSubmit() {
      if (!this.form.deliveryDate) {
        this.$message.warning('请选择发货日期')
        return
      }
      if (!this.form.trackingNo) {
        this.$message.warning('请输入快递单号')
        return
      }
      if (!this.form.deliveryNote) {
        this.$message.warning('请上传发货单')
        return
      }
      if (!this.form.expressPhoto) {
        this.$message.warning('请上传快递单照片')
        return
      }
      
      const selectedMaterials = this.materials.filter(m => m.currentQuantity > 0)
      if (selectedMaterials.length === 0) {
        this.$message.warning('请选择要发货的物料')
        return
      }

      // 计算本次发货的总数量
      const totalShipped = this.materials.reduce((sum, item) => sum + (item.currentQuantity || 0), 0)
      
      this.$http.post('/api/delivery/record', {
        ...this.form,
        orderId: this.orderId
      }).then(res => {
        if (res.data.code === 200) {
          // 更新采购订单的已发货数量
          this.$http.get('/api/purchase/order/' + this.orderId).then(orderRes => {
            if (orderRes.data.code === 200) {
              const order = orderRes.data.data
              const updateData = {
                id: order.id,
                shippedQuantity: (order.shippedQuantity || 0) + totalShipped,
                status: 2 // 始终更新为部分发货状态，只有点击已完成才变为全部发货
              }
              this.$http.put('/api/purchase/order', updateData).then(updateRes => {
                if (updateRes.data.code === 200) {
                  this.$message.success('发货成功')
                  this.$router.push('/supplier/order/pending')
                }
              })
            }
          })
        }
      })
    },
    handleCancel() {
      this.$router.push('/supplier/order/pending')
    }
  }
}
</script>

<style scoped>
.page-container {
  padding: 10px;
}
.card-header {
  font-weight: bold;
}
.order-summary {
  margin-bottom: 20px;
}
.material-image {
  width: 60px;
  height: 60px;
  object-fit: cover;
}
.material-upload-icon {
  font-size: 28px;
  color: #8c939d;
  line-height: 60px;
}
</style>
