<template>
  <div class="page-container">
    <el-card>
      <div slot="header" class="card-header">
        <span>发货记录</span>
      </div>
      <el-table :data="tableData" border stripe>
        <el-table-column prop="deliveryNo" label="发货单号" width="180"></el-table-column>
        <el-table-column prop="deliveryDate" label="发货日期" width="120"></el-table-column>
        <el-table-column prop="trackingNo" label="快递单号" width="150"></el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template slot-scope="scope">
            <el-tag :type="scope.row.status === 1 ? 'success' : 'primary'">
              {{ scope.row.status === 1 ? '已收货' : '已发货' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="180"></el-table-column>
        <el-table-column label="操作" width="150" fixed="right">
          <template slot-scope="scope">
            <el-button type="text" size="small" @click="handleView(scope.row)">查看</el-button>
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
  name: 'DeliveryList',
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
        }
      })
    },
    handlePageChange(page) {
      this.pagination.current = page
      this.loadData()
    },
    handleView(row) {
      this.$alert(JSON.stringify(row, null, 2), '发货详情', {
        customClass: 'json-alert',
        confirmButtonText: '关闭'
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
