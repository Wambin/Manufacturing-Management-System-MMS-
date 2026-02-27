<template>
  <div class="page-container">
    <el-card>
      <div class="toolbar">
        <el-form :inline="true" class="search-form">
          <el-form-item label="状态">
            <el-select v-model="searchForm.status" placeholder="全部" clearable style="width: 150px">
              <el-option label="草稿" :value="0"></el-option>
              <el-option label="待履约" :value="1"></el-option>
              <el-option label="部分发货" :value="2"></el-option>
              <el-option label="已发货" :value="3"></el-option>
              <el-option label="已收货" :value="4"></el-option>
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="loadData">查询</el-button>
            <el-button @click="resetSearch">重置</el-button>
          </el-form-item>
        </el-form>
        <div class="toolbar-right">
          <el-button type="primary" @click="handleAdd">
            <i class="el-icon-plus"></i> 新增订单
          </el-button>
        </div>
      </div>

      <el-table :data="tableData" border stripe>
        <el-table-column prop="orderNo" label="订单号" width="180"></el-table-column>
        <el-table-column label="采购申请" width="120">
          <template slot-scope="scope">
            <span v-if="scope.row.requestNo">{{ scope.row.requestNo }}</span>
            <span v-else-if="scope.row.requestId">加载中...</span>
            <span v-else>无</span>
          </template>
        </el-table-column>
        <el-table-column prop="contractNo" label="合同号" width="150"></el-table-column>
        <el-table-column prop="deliveryDate" label="交货日期" width="120"></el-table-column>
        <el-table-column prop="totalQuantity" label="总数" width="80"></el-table-column>
        <el-table-column prop="shippedQuantity" label="已发货" width="80"></el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template slot-scope="scope">
            <el-tag :type="getStatusType(scope.row.status)">{{ getStatusText(scope.row.status) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="180"></el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template slot-scope="scope">
            <el-button type="text" size="small" @click="handleView(scope.row)">查看</el-button>
            <template v-if="scope.row.status === 0">
              <el-button type="text" size="small" @click="handleEdit(scope.row)">编辑</el-button>
            </template>
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
  name: 'PurchaseOrderList',
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
      this.$http.get('/api/purchase/order/list', {
        params: {
          current: this.pagination.current,
          size: this.pagination.size,
          status: this.searchForm.status
        }
      }).then(res => {
        if (res.data.code === 200) {
          this.tableData = res.data.data.records
          this.pagination.total = res.data.data.total
          // 加载采购申请信息，获取申请单号
          this.loadRequestInfo()
        }
      })
    },
    loadRequestInfo() {
      // 收集所有订单的采购申请ID
      const requestIds = this.tableData
        .filter(item => item.requestId)
        .map(item => item.requestId)
      
      if (requestIds.length > 0) {
        // 优化：使用Set去重，减少API调用
        const uniqueRequestIds = [...new Set(requestIds)]
        
        // 批量处理，每个API调用都设置超时
        uniqueRequestIds.forEach(requestId => {
          // 设置5秒超时
          const timeoutPromise = new Promise((_, reject) => {
            setTimeout(() => reject(new Error('请求超时')), 5000)
          })
          
          // 使用Promise.race确保请求不会无限等待
          Promise.race([
            this.$http.get(`/api/purchase/request/${requestId}`),
            timeoutPromise
          ]).then(res => {
            if (res.data && res.data.code === 200) {
              const request = res.data.data
              // 找到对应的订单并更新申请单号
              this.tableData.forEach(order => {
                if (order.requestId === requestId) {
                  order.requestNo = request.requestNo
                }
              })
            } else {
              // API调用成功但返回错误码
              this.tableData.forEach(order => {
                if (order.requestId === requestId) {
                  order.requestNo = '无'
                }
              })
            }
          }).catch(() => {
            // API调用失败或超时
            this.tableData.forEach(order => {
              if (order.requestId === requestId) {
                order.requestNo = '无'
              }
            })
          })
        })
      }
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
      this.$router.push('/purchase/order/edit')
    },
    handleEdit(row) {
      this.$router.push('/purchase/order/edit?id=' + row.id)
    },
    handleView(row) {
      this.$router.push('/purchase/order/edit?id=' + row.id + '&view=true')
    },
    getStatusType(status) {
      const map = { 0: 'info', 1: 'warning', 2: 'primary', 3: 'success', 4: 'success' }
      return map[status] || ''
    },
    getStatusText(status) {
      const map = { 0: '草稿', 1: '待履约', 2: '部分发货', 3: '已发货', 4: '已收货' }
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
