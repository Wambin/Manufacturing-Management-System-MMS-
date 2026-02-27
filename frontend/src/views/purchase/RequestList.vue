<template>
  <div class="page-container">
    <el-card>
      <div class="toolbar">
        <el-form :inline="true" class="search-form">
          <el-form-item label="状态">
            <el-select v-model="searchForm.status" placeholder="全部" clearable style="width: 120px">
              <el-option label="草稿" :value="0"></el-option>
              <el-option label="待审核" :value="1"></el-option>
              <el-option label="通过" :value="2"></el-option>
              <el-option label="驳回" :value="3"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="loadData">查询</el-button>
            <el-button @click="resetSearch">重置</el-button>
          </el-form-item>
        </el-form>
        <div class="toolbar-right">
          <el-button type="primary" @click="handleAdd">
            <i class="el-icon-plus"></i> 新增
          </el-button>
        </div>
      </div>

      <el-table :data="tableData" border stripe>
        <el-table-column prop="requestNo" label="申请单号" width="180"></el-table-column>
        <el-table-column prop="expectDate" label="期望到货日" width="120"></el-table-column>
        <el-table-column prop="priority" label="优先级" width="100">
          <template slot-scope="scope">
            <el-tag :type="getPriorityType(scope.row.priority)">{{ getPriorityText(scope.row.priority) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template slot-scope="scope">
            <el-tag :type="getStatusType(scope.row.status)">{{ getStatusText(scope.row.status) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="申请时间" width="180"></el-table-column>
        <el-table-column label="操作" width="300" fixed="right">
          <template slot-scope="scope">
            <el-button type="text" size="small" @click="handleView(scope.row)">查看</el-button>
            <template v-if="scope.row.status === 0">
              <el-button type="text" size="small" @click="handleEdit(scope.row)">编辑</el-button>
              <el-button type="text" size="small" @click="handleSubmit(scope.row)">提交</el-button>
              <el-button type="text" size="small" @click="handleDelete(scope.row)" style="color: #f56c6c">删除</el-button>
            </template>
            <el-button v-if="scope.row.status === 2" type="text" size="small" @click="handleGenerateOrder(scope.row)" style="color: #67c23a">生成订单</el-button>
          </template>
        </el-table-column>
      </el-table>

      <el-pagination
        @current-change="handlePageChange"
        :current-page="pagination.current"
        :page-size="pagination.size"
        :total="pagination.total"
        layout="total, prev, pager, next"
        style="margin-top: 20px; text-align: right">
      </el-pagination>
    </el-card>
  </div>
</template>

<script>
export default {
  name: 'PurchaseRequestList',
  data() {
    return {
      searchForm: {
        status: null
      },
      tableData: [],
      pagination: {
        current: 1,
        size: 10,
        total: 0
      }
    }
  },
  mounted() {
    this.loadData()
  },
  methods: {
    loadData() {
      this.$http.get('/api/purchase/request/list', {
        params: {
          current: this.pagination.current,
          size: this.pagination.size,
          status: this.searchForm.status
        }
      }).then(res => {
        if (res.data.code === 200) {
          this.tableData = res.data.data.records
          this.pagination.total = res.data.data.total
        }
      })
    },
    resetSearch() {
      this.searchForm.status = null
      this.pagination.current = 1
      this.loadData()
    },
    handlePageChange(page) {
      this.pagination.current = page
      this.loadData()
    },
    handleAdd() {
      this.$router.push('/purchase/request/edit')
    },
    handleEdit(row) {
      this.$router.push('/purchase/request/edit?id=' + row.id)
    },
    handleView(row) {
      this.$router.push('/purchase/request/edit?id=' + row.id + '&view=true')
    },
    handleSubmit(row) {
      this.$confirm('确定要提交该采购申请吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$http.put('/api/purchase/request/' + row.id + '/submit').then(res => {
          if (res.data.code === 200) {
            this.$message.success('提交成功')
            this.loadData()
          }
        })
      }).catch(() => {})
    },
    handleDelete(row) {
      this.$confirm('确定要删除该采购申请吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$http.delete('/api/purchase/request/' + row.id).then(res => {
          if (res.data.code === 200) {
            this.$message.success('删除成功')
            this.loadData()
          }
        })
      }).catch(() => {})
    },
    getPriorityType(priority) {
      const map = { low: '', normal: '', high: 'danger' }
      return map[priority] || ''
    },
    getPriorityText(priority) {
      const map = { low: '低', normal: '普通', high: '高' }
      return map[priority] || priority
    },
    handleGenerateOrder(request) {
      // 跳转到采购订单编辑页面，并传递采购申请信息
      this.$router.push({
        path: '/purchase/order/edit',
        query: {
          requestId: request.id,
          projectId: request.projectId,
          materials: request.materials
        }
      })
    },
    getStatusType(status) {
      const map = { 0: 'info', 1: 'warning', 2: 'success', 3: 'danger' }
      return map[status] || ''
    },
    getStatusText(status) {
      const map = { 0: '草稿', 1: '待审核', 2: '通过', 3: '驳回' }
      return map[status] || status
    }
  }
}
</script>

<style scoped>
.page-container {
  padding: 10px;
}
.toolbar {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 20px;
}
.search-form {
  margin-bottom: 0;
}
</style>
