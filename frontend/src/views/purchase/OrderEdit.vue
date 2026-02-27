<template>
  <div class="page-container">
    <el-card>
      <div slot="header" class="card-header">
        <span>{{ isView ? '查看订单' : (isEdit ? '编辑订单' : '新增订单') }}</span>
      </div>
      <el-form :model="form" label-width="120px">
        <!-- 新增订单时选择采购申请 -->
        <el-row :gutter="20" v-if="!isEdit && !requestId">
          <el-col :span="24">
            <el-form-item label="采购申请">
              <el-select v-model="selectedRequestId" placeholder="请选择已通过的采购申请" style="width: 100%" @change="handleRequestSelect">
                <el-option v-for="item in requestList" :key="item.id" :label="item.requestNo + ' - ' + (item.projectName || '未指定项目')" :value="item.id"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        
        <!-- 订单基本信息 -->
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="项目">
              <el-select v-model="form.projectId" placeholder="请选择项目" style="width: 100%" :disabled="isView || (!isEdit && selectedRequestId)">
                <el-option v-for="item in projectList" :key="item.id" :label="item.projectName" :value="item.id"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="供应商">
              <el-select v-model="form.supplierId" placeholder="请选择供应商" style="width: 100%" :disabled="isView">
                <el-option v-for="item in supplierList" :key="item.id" :label="item.name" :value="item.id"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="合同号">
              <el-input v-model="form.contractNo" placeholder="自动生成" :disabled="isView" style="width: 80%"></el-input>
              <el-button v-if="!isView" type="primary" size="small" @click="generateContractNo" style="margin-left: 10px">生成</el-button>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="采购日期">
              <el-date-picker v-model="form.purchaseDate" type="date" placeholder="选择日期" style="width: 100%" value-format="yyyy-MM-dd" :disabled="isView"></el-date-picker>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="交货日期">
              <el-date-picker v-model="form.deliveryDate" type="date" placeholder="选择日期" style="width: 100%" value-format="yyyy-MM-dd" :disabled="isView"></el-date-picker>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="状态">
              <el-select v-model="form.status" style="width: 100%" :disabled="isView">
                <el-option label="草稿" :value="0"></el-option>
                <el-option label="待履约" :value="1"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>

        <el-divider content-position="left">物料清单</el-divider>

        <div style="margin-bottom: 10px" v-if="!isView">
          <el-button type="primary" size="small" @click="handleAddMaterial">
            <i class="el-icon-plus"></i> 添加物料
          </el-button>
        </div>

        <el-table :data="materials" border style="margin-bottom: 20px">
          <el-table-column label="物料编码" width="120">
            <template slot-scope="scope">
              <el-input v-model="scope.row.materialCode" placeholder="编码" size="small" :disabled="isView"></el-input>
            </template>
          </el-table-column>
          <el-table-column label="物料名称" width="150">
            <template slot-scope="scope">
              <el-input v-model="scope.row.materialName" placeholder="名称" size="small" :disabled="isView"></el-input>
            </template>
          </el-table-column>
          <el-table-column label="规格" width="120">
            <template slot-scope="scope">
              <el-input v-model="scope.row.specification" placeholder="规格" size="small" :disabled="isView"></el-input>
            </template>
          </el-table-column>
          <el-table-column label="数量" width="120">
            <template slot-scope="scope">
              <el-input-number v-model="scope.row.quantity" :min="1" size="small" style="width: 100%" :disabled="isView"></el-input-number>
            </template>
          </el-table-column>
          <el-table-column label="单价" width="120">
            <template slot-scope="scope">
              <el-input-number v-model="scope.row.price" :min="0" :precision="2" size="small" style="width: 100%" :disabled="isView"></el-input-number>
            </template>
          </el-table-column>
          <el-table-column label="单位" width="80">
            <template slot-scope="scope">
              <el-input v-model="scope.row.unit" placeholder="单位" size="small" :disabled="isView"></el-input>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="80" v-if="!isView">
            <template slot-scope="scope">
              <el-button type="text" size="small" @click="handleRemoveMaterial(scope.$index)" style="color: #f56c6c">删除</el-button>
            </template>
          </el-table-column>
        </el-table>

        <el-form-item v-if="!isView">
          <el-button type="primary" @click="handleSave">保存</el-button>
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
  name: 'PurchaseOrderEdit',
  data() {
    return {
      isEdit: false,
      isView: false,
      requestId: null,
      selectedRequestId: null,
      form: {
        id: null,
        projectId: null,
        supplierId: null,
        requestId: null,
        contractNo: '',
        purchaseDate: '',
        deliveryDate: '',
        status: 0,
        materials: '[]'
      },
      projectList: [],
      supplierList: [],
      requestList: [],
      materials: []
    }
  },
  mounted() {
    this.loadProjects()
    this.loadSuppliers()
    this.loadApprovedRequests()
    const id = this.$route.query.id
    this.isView = this.$route.query.view === 'true'
    
    // 检查是否从采购申请跳转过来
    this.requestId = this.$route.query.requestId
    if (this.requestId) {
      this.form.requestId = this.requestId
      this.form.projectId = this.$route.query.projectId
      const materials = this.$route.query.materials
      if (materials) {
        try {
          this.materials = JSON.parse(materials)
        } catch (e) {
          console.error('Failed to parse materials:', e)
        }
      }
      // 自动生成合同号
      this.generateContractNo()
    }
    
    if (id) {
      this.isEdit = true
      this.loadData(id)
    }
  },
  methods: {
    loadProjects() {
      this.$http.get('/api/project/all').then(res => {
        if (res.data.code === 200) {
          this.projectList = res.data.data
        }
      })
    },
    loadSuppliers() {
      this.$http.get('/api/supplier/all').then(res => {
        if (res.data.code === 200) {
          this.supplierList = res.data.data
        }
      })
    },
    loadApprovedRequests() {
      // 加载已通过的采购申请
      this.$http.get('/api/purchase/request/list', {
        params: {
          current: 1,
          size: 100,
          status: 2
        }
      }).then(res => {
        if (res.data.code === 200) {
          this.requestList = res.data.data.records
        }
      })
    },
    handleRequestSelect(requestId) {
      // 选择采购申请后加载详情
      this.$http.get('/api/purchase/request/' + requestId).then(res => {
        if (res.data.code === 200) {
          const request = res.data.data
          this.form.requestId = requestId
          this.form.projectId = request.projectId
          try {
            this.materials = JSON.parse(request.materials)
          } catch (e) {
            console.error('Failed to parse materials:', e)
          }
          // 自动生成合同号
          this.generateContractNo()
        }
      })
    },
    generateContractNo() {
      // 生成合同号：CONTRACT + 年月日 + 6位随机数
      const date = new Date()
      const year = date.getFullYear()
      const month = String(date.getMonth() + 1).padStart(2, '0')
      const day = String(date.getDate()).padStart(2, '0')
      const random = Math.floor(100000 + Math.random() * 900000)
      this.form.contractNo = `CONTRACT${year}${month}${day}${random}`
    },
    loadData(id) {
      this.$http.get('/api/purchase/order/' + id).then(res => {
        if (res.data.code === 200) {
          this.form = res.data.data
          this.materials = this.parseMaterials(this.form.materials)
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
    handleSave() {
      // 计算订单总数
      this.form.totalQuantity = this.materials.reduce((sum, item) => sum + (item.quantity || 0), 0)
      // 初始已发货数量为0
      if (!this.form.shippedQuantity) {
        this.form.shippedQuantity = 0
      }
      // 初始已收货数量为0
      if (!this.form.receivedQuantity) {
        this.form.receivedQuantity = 0
      }
      this.form.materials = JSON.stringify(this.materials)
      const request = this.isEdit ? this.$http.put('/api/purchase/order', this.form) : this.$http.post('/api/purchase/order', this.form)
      request.then(res => {
        if (res.data.code === 200) {
          this.$message.success('保存成功')
          this.$router.push('/purchase/order/list')
        }
      })
    },
    handleCancel() {
      this.$router.push('/purchase/order/list')
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
</style>
