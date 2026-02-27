<template>
  <div class="page-container">
    <el-card>
      <div slot="header" class="card-header">
        <span>采购申请审核</span>
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
            <el-tag type="warning">待审核</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="申请时间" width="180"></el-table-column>
        <el-table-column label="操作" width="250" fixed="right">
          <template slot-scope="scope">
            <el-button type="text" size="small" @click="handleView(scope.row)">查看</el-button>
            <el-button type="text" size="small" @click="handleApprove(scope.row)">通过</el-button>
            <el-button type="text" size="small" @click="handleReject(scope.row)" style="color: #f56c6c">驳回</el-button>
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

    <el-dialog :title="'审核 - ' + currentRequest?.requestNo" :visible.sync="auditDialogVisible" width="500px">
      <el-form :model="auditForm" label-width="100px">
        <el-form-item label="审核意见">
          <el-input v-model="auditForm.opinion" type="textarea" :rows="4"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="auditDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleAuditSubmit">确定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'PurchaseRequestConfirm',
  data() {
    return {
      tableData: [],
      pagination: {
        current: 1,
        size: 10,
        total: 0
      },
      auditDialogVisible: false,
      currentRequest: null,
      auditType: '',
      auditForm: {
        opinion: ''
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
          status: 1
        }
      }).then(res => {
        if (res.data.code === 200) {
          this.tableData = res.data.data.records
          this.pagination.total = res.data.data.total
        }
      })
    },
    handlePageChange(page) {
      this.pagination.current = page
      this.loadData()
    },
    handleView(row) {
      this.$router.push('/purchase/request/edit?id=' + row.id + '&view=true')
    },
    handleApprove(row) {
      this.currentRequest = row
      this.auditType = 'approve'
      this.auditForm.opinion = '同意'
      this.auditDialogVisible = true
    },
    handleReject(row) {
      this.currentRequest = row
      this.auditType = 'reject'
      this.auditForm.opinion = ''
      this.auditDialogVisible = true
    },
    handleAuditSubmit() {
      const user = this.$store.state.user
      const url = this.auditType === 'approve' 
        ? '/api/purchase/request/' + this.currentRequest.id + '/approve'
        : '/api/purchase/request/' + this.currentRequest.id + '/reject'
      
      this.$http.put(url, null, {
        params: {
          auditUserId: user?.id,
          opinion: this.auditForm.opinion
        }
      }).then(res => {
        if (res.data.code === 200) {
          this.$message.success('审核成功')
          this.auditDialogVisible = false
          this.loadData()
        }
      })
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
    getPriorityType(priority) {
      const map = { low: '', normal: '', high: 'danger' }
      return map[priority] || ''
    },
    getPriorityText(priority) {
      const map = { low: '低', normal: '普通', high: '高' }
      return map[priority] || priority
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
