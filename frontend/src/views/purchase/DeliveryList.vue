<template>
  <div class="page-container">
    <el-card>
      <div slot="header" class="card-header">
        <span>发货记录</span>
      </div>
      <el-table :data="tableData" border stripe>
        <el-table-column prop="deliveryNo" label="发货单号" width="180"></el-table-column>
        <el-table-column label="订单号" width="180">
          <template slot-scope="scope">
            <span>{{ scope.row.orderNo || '加载中...' }}</span>
          </template>
        </el-table-column>
        <el-table-column prop="deliveryDate" label="发货日期" width="120"></el-table-column>
        <el-table-column prop="trackingNo" label="快递单号" width="150"></el-table-column>
        <el-table-column prop="contactPerson" label="联系人" width="100"></el-table-column>
        <el-table-column prop="contactPhone" label="联系电话" width="120"></el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template slot-scope="scope">
            <el-tag :type="scope.row.status === 1 ? 'success' : 'primary'">
              {{ scope.row.status === 1 ? '已收货' : '已发货' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="180"></el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template slot-scope="scope">
            <el-button type="text" size="small" @click="handleView(scope.row)">查看详情</el-button>
            <el-button v-if="scope.row.status === 0" type="primary" size="small" @click="handleConfirmReceive(scope.row)">确认收货</el-button>
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
  name: 'PurchaseDeliveryList',
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
      this.$http.get('/api/delivery/record/list', {
        params: {
          current: this.pagination.current,
          size: this.pagination.size
        }
      }).then(res => {
        if (res.data.code === 200) {
          this.tableData = res.data.data.records
          this.pagination.total = res.data.data.total
          // 加载订单信息
          this.loadOrderInfo()
        }
      })
    },
    loadOrderInfo() {
      // 收集所有发货记录的订单ID
      const orderIds = this.tableData
        .filter(item => item.orderId)
        .map(item => item.orderId)
      
      if (orderIds.length > 0) {
        // 这里简化处理，实际应该调用批量查询接口
        orderIds.forEach(orderId => {
          this.$http.get(`/api/purchase/order/${orderId}`).then(res => {
            if (res.data.code === 200) {
              const order = res.data.data
              // 找到对应的发货记录并更新订单号
              const delivery = this.tableData.find(item => item.orderId === orderId)
              if (delivery) {
                delivery.orderNo = order.orderNo
              }
            }
          })
        })
      }
    },
    getPhotoCount(row) {
      let count = 0
      if (row.expressPhoto) count++
      if (row.packagingPhotos) count++
      if (row.productPhotos) count++
      if (row.certificate) count++
      return count
    },
    getPhotoArray(photoStr) {
      if (!photoStr) return []
      try {
        const photos = JSON.parse(photoStr)
        return Array.isArray(photos) ? photos : [photos]
      } catch {
        return [photoStr]
      }
    },
    handlePageChange(page) {
      this.pagination.current = page
      this.loadData()
    },
    handleView(row) {
      this.$router.push(`/purchase/delivery/view?id=${row.id}`)
    },
    handleConfirmReceive(row) {
      this.$confirm('确定要确认收货吗？', '警告', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$http.put(`/api/delivery/record/${row.id}/receive`).then(res => {
          if (res.data.code === 200) {
            this.$message.success('确认收货成功')
            this.loadData()
          }
        })
      }).catch(() => {
        // 取消确认
      })
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
</style>