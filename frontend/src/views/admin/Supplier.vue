<template>
  <div class="page-container">
    <el-card>
      <div class="toolbar">
        <el-form :inline="true" class="search-form">
          <el-form-item label="供应商名称">
            <el-input v-model="searchForm.name" placeholder="请输入名称" style="width: 200px"></el-input>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="loadData">查询</el-button>
            <el-button @click="resetSearch">重置</el-button>
          </el-form-item>
        </el-form>
        <div class="toolbar-right">
          <el-button type="primary" @click="handleAdd">
            <i class="el-icon-plus"></i> 新增供应商
          </el-button>
        </div>
      </div>

      <el-table :data="tableData" border stripe>
        <el-table-column prop="id" label="ID" width="80"></el-table-column>
        <el-table-column prop="name" label="供应商名称" width="180"></el-table-column>
        <el-table-column prop="contactPerson" label="联系人" width="100"></el-table-column>
        <el-table-column prop="phone" label="电话" width="120"></el-table-column>
        <el-table-column prop="email" label="邮箱" width="150"></el-table-column>
        <el-table-column prop="address" label="地址" width="200"></el-table-column>
        <el-table-column prop="status" label="状态" width="80">
          <template slot-scope="scope">
            <el-tag :type="scope.row.status === 1 ? 'success' : 'danger'">
              {{ scope.row.status === 1 ? '启用' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="180"></el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template slot-scope="scope">
            <el-button type="text" size="small" @click="handleEdit(scope.row)">编辑</el-button>
            <el-button type="text" size="small" @click="handleDelete(scope.row)" style="color: #f56c6c">删除</el-button>
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

    <!-- 编辑对话框 -->
    <el-dialog
      :title="dialogTitle"
      :visible.sync="dialogVisible"
      width="600px"
      :close-on-click-modal="false"
    >
      <el-form :model="form" label-width="120px">
        <el-row :gutter="20">
          <el-col :span="24">
            <el-form-item label="供应商名称" required>
              <el-input v-model="form.name" placeholder="请输入供应商名称" style="width: 100%"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="联系人">
              <el-input v-model="form.contactPerson" placeholder="请输入联系人" style="width: 100%"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="电话">
              <el-input v-model="form.phone" placeholder="请输入电话" style="width: 100%"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="邮箱">
              <el-input v-model="form.email" placeholder="请输入邮箱" style="width: 100%"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="状态">
              <el-select v-model="form.status" placeholder="请选择状态" style="width: 100%">
                <el-option label="启用" :value="1"></el-option>
                <el-option label="禁用" :value="0"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="24">
            <el-form-item label="地址">
              <el-input v-model="form.address" placeholder="请输入地址" type="textarea" :rows="2"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSave">保存</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'SupplierManage',
  data() {
    return {
      searchForm: {
        name: ''
      },
      tableData: [],
      pagination: {
        current: 1,
        size: 10,
        total: 0
      },
      dialogVisible: false,
      dialogTitle: '',
      form: {
        id: null,
        name: '',
        contactPerson: '',
        phone: '',
        email: '',
        address: '',
        status: 1
      }
    }
  },
  mounted() {
    this.loadData()
  },
  methods: {
    loadData() {
      this.$http.get('/api/supplier/list', {
        params: {
          current: this.pagination.current,
          size: this.pagination.size,
          name: this.searchForm.name
        }
      }).then(res => {
        if (res.data.code === 200) {
          this.tableData = res.data.data.records
          this.pagination.total = res.data.data.total
        }
      })
    },
    resetSearch() {
      this.searchForm.name = ''
      this.pagination.current = 1
      this.loadData()
    },
    handlePageChange(current) {
      this.pagination.current = current
      this.loadData()
    },
    handleAdd() {
      this.dialogTitle = '新增供应商'
      this.form = {
        id: null,
        name: '',
        contactPerson: '',
        phone: '',
        email: '',
        address: '',
        status: 1
      }
      this.dialogVisible = true
    },
    handleEdit(row) {
      this.dialogTitle = '编辑供应商'
      this.form = {
        id: row.id,
        name: row.name,
        contactPerson: row.contactPerson,
        phone: row.phone,
        email: row.email,
        address: row.address,
        status: row.status
      }
      this.dialogVisible = true
    },
    handleSave() {
      if (!this.form.name) {
        this.$message.error('请输入供应商名称')
        return
      }
      
      const request = this.form.id
        ? this.$http.put('/api/supplier', this.form)
        : this.$http.post('/api/supplier', this.form)
      
      request.then(res => {
        if (res.data.code === 200) {
          this.$message.success('保存成功')
          this.dialogVisible = false
          this.loadData()
        }
      })
    },
    handleDelete(row) {
      this.$confirm('确定要删除该供应商吗？', '警告', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$http.delete('/api/supplier/' + row.id).then(res => {
          if (res.data.code === 200) {
            this.$message.success('删除成功')
            this.loadData()
          }
        })
      }).catch(() => {
        // 取消删除
      })
    }
  }
}
</script>

<style scoped>
.page-container {
  padding: 20px;
}

.toolbar {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.search-form {
  display: flex;
  align-items: center;
}

.toolbar-right {
  margin-left: auto;
}

.dialog-footer {
  text-align: right;
}
</style>