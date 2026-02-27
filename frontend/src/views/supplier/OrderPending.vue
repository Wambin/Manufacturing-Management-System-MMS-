<template>
  <div class="page-container">
    <el-card>
      <div slot="header" class="card-header">
        <span>待履约订单</span>
      </div>
      <el-table :data="tableData" border stripe>
        <el-table-column prop="orderNo" label="订单号" width="180"></el-table-column>
        <el-table-column prop="contractNo" label="合同号" width="150"></el-table-column>
        <el-table-column prop="deliveryDate" label="交货期限" width="120"></el-table-column>
        <el-table-column prop="shippedQuantity" label="已发货" width="100"></el-table-column>
        <el-table-column label="已收货" width="100">
          <template slot-scope="scope">
            {{ scope.row.receivedQuantity || 0 }}
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template slot-scope="scope">
            <el-tag :type="getStatusType(scope.row)">{{ getStatusText(scope.row) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="下单时间" width="180"></el-table-column>
        <el-table-column label="操作" width="250" fixed="right">
          <template slot-scope="scope">
            <el-button type="text" size="small" @click="handleView(scope.row)">查看</el-button>
            <template v-if="scope.row.status != 3">
              <el-button type="text" size="small" @click="handleDelivery(scope.row)">发货</el-button>
              <el-button type="text" size="small" style="color: #67c23a" @click="handleComplete(scope.row)">已完成</el-button>
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
  name: 'SupplierOrderPending',
  data() {
    return {
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
      const user = this.$store.state.user
      const supplierId = user ? user.supplierId : null
      
      this.$http.get('/api/purchase/order/list', {
        params: {
          current: this.pagination.current,
          size: this.pagination.size,
          supplierId: supplierId
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
      this.$router.push('/supplier/delivery/edit?orderId=' + row.id + '&view=true')
    },
    handleDelivery(row) {
      this.$router.push('/supplier/delivery/edit?orderId=' + row.id)
    },
    getStatusType(row) {
      // 根据发货数量和状态判断
      if (row.status === 0) {
        return 'info'
      }
      if (row.status === 4) {
        return 'success'
      }
      if (row.shippedQuantity === 0) {
        return 'warning'
      }
      if (row.status === 3) {
        return 'success'
      }
      return 'primary'
    },
    getStatusText(row) {
      // 严格按照状态规则判断
      if (row.status === 0) {
        return '草稿'
      }
      if (row.status === 3 && row.receivedQuantity === row.shippedQuantity && row.shippedQuantity > 0) {
        return '订单完成'
      }
      if (row.shippedQuantity === 0) {
        return '未发货'
      }
      if (row.status === 3) {
        return '全部发货'
      }
      return '部分发货'
    },
    handleComplete(row) {
      this.$confirm('确定要将订单标记为已完成吗？完成后将不能再发货。', '警告', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        // 检查发货数量是否等于收货数量
        let status = 3 // 默认全部发货
        if (row.receivedQuantity === row.shippedQuantity && row.shippedQuantity > 0) {
          status = 3 // 仍然使用3状态，因为状态显示逻辑已经修改
        }
        // 更新订单状态
        const updateData = {
          id: row.id,
          status: status
        }
        this.$http.put('/api/purchase/order', updateData).then(res => {
          if (res.data.code === 200) {
            this.$message.success('订单已标记为已完成')
            this.loadData()
          }
        })
      }).catch(() => {
        // 取消操作
      })
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
