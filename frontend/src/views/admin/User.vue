<template>
  <div class="page-container">
    <el-card>
      <div class="toolbar">
        <el-form :inline="true" class="search-form">
          <el-form-item label="关键词">
            <el-input v-model="searchForm.keyword" placeholder="用户名/姓名"></el-input>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="loadData">查询</el-button>
            <el-button @click="resetSearch">重置</el-button>
          </el-form-item>
        </el-form>
        <div class="toolbar-right">
          <el-button type="primary" @click="handleAdd">
            <i class="el-icon-plus"></i> 新增用户
          </el-button>
        </div>
      </div>

      <el-table :data="tableData" border stripe>
        <el-table-column prop="username" label="用户名" width="120"></el-table-column>
        <el-table-column prop="realName" label="真实姓名" width="120"></el-table-column>
        <el-table-column prop="role" label="角色" width="120">
          <template slot-scope="scope">
            <el-tag :type="getRoleType(scope.row.role)">{{ getRoleText(scope.row.role) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="phone" label="电话" width="130"></el-table-column>
        <el-table-column prop="email" label="邮箱"></el-table-column>
        <el-table-column prop="status" label="状态" width="80">
          <template slot-scope="scope">
            <el-tag :type="scope.row.status === 1 ? 'success' : 'danger'">
              {{ scope.row.status === 1 ? '启用' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="lastLoginTime" label="最后登录" width="180"></el-table-column>
        <el-table-column label="操作" width="250" fixed="right">
          <template slot-scope="scope">
            <el-button type="text" size="small" @click="handleEdit(scope.row)">编辑</el-button>
            <el-button type="text" size="small" @click="handleResetPassword(scope.row)">重置密码</el-button>
            <el-button type="text" size="small" @click="handleToggleStatus(scope.row)">
              {{ scope.row.status === 1 ? '禁用' : '启用' }}
            </el-button>
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

    <el-dialog :title="isEdit ? '编辑用户' : '新增用户'" :visible.sync="dialogVisible" width="500px">
      <el-form :model="userForm" :rules="rules" ref="userForm" label-width="100px">
        <el-form-item label="用户名" prop="username">
          <el-input v-model="userForm.username" :disabled="isEdit"></el-input>
        </el-form-item>
        <el-form-item label="密码" prop="password" v-if="!isEdit">
          <el-input v-model="userForm.password" type="password"></el-input>
        </el-form-item>
        <el-form-item label="真实姓名" prop="realName">
          <el-input v-model="userForm.realName"></el-input>
        </el-form-item>
        <el-form-item label="角色" prop="role">
          <el-select v-model="userForm.role" style="width: 100%" @change="handleRoleChange">
            <el-option label="管理员" value="admin"></el-option>
            <el-option label="项目经理" value="project_manager"></el-option>
            <el-option label="采购员" value="purchaser"></el-option>
            <el-option label="供应商" value="supplier"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="供应商" v-if="userForm.role === 'supplier'" prop="supplierId">
          <el-select v-model="userForm.supplierId" placeholder="请选择供应商" style="width: 100%">
            <el-option v-for="supplier in supplierList" :key="supplier.id" :label="supplier.name" :value="supplier.id"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="电话">
          <el-input v-model="userForm.phone"></el-input>
        </el-form-item>
        <el-form-item label="邮箱">
          <el-input v-model="userForm.email"></el-input>
        </el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="userForm.status">
            <el-radio :label="1">启用</el-radio>
            <el-radio :label="0">禁用</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <div slot="footer">
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit">确定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'AdminUser',
  data() {
    return {
      searchForm: {
        keyword: ''
      },
      tableData: [],
      supplierList: [],
      pagination: {
        current: 1,
        size: 10,
        total: 0
      },
      dialogVisible: false,
      isEdit: false,
      userForm: {
        id: null,
        username: '',
        password: '123456',
        realName: '',
        role: 'purchaser',
        supplierId: null,
        phone: '',
        email: '',
        status: 1
      },
      rules: {
        username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
        password: [{ required: true, message: '请输入密码', trigger: 'blur' }],
        realName: [{ required: true, message: '请输入真实姓名', trigger: 'blur' }],
        role: [{ required: true, message: '请选择角色', trigger: 'change' }],
        supplierId: [{ required: true, message: '请选择供应商', trigger: 'change' }]
      }
    }
  },
  mounted() {
    this.loadData()
    this.loadSuppliers()
  },
  methods: {
    loadSuppliers() {
      this.$http.get('/api/supplier/all').then(res => {
        if (res.data.code === 200) {
          this.supplierList = res.data.data
        }
      })
    },
    handleRoleChange(role) {
      if (role !== 'supplier') {
        this.userForm.supplierId = null
      }
    },
    loadData() {
      this.$http.get('/api/user/list', {
        params: {
          current: this.pagination.current,
          size: this.pagination.size,
          keyword: this.searchForm.keyword
        }
      }).then(res => {
        if (res.data.code === 200) {
          this.tableData = res.data.data.records
          this.pagination.total = res.data.data.total
        }
      })
    },
    resetSearch() {
      this.searchForm.keyword = ''
      this.pagination.current = 1
      this.loadData()
    },
    handlePageChange(page) {
      this.pagination.current = page
      this.loadData()
    },
    handleAdd() {
      this.isEdit = false
      this.userForm = {
        id: null,
        username: '',
        password: '123456',
        realName: '',
        role: 'purchaser',
        supplierId: null,
        phone: '',
        email: '',
        status: 1
      }
      this.dialogVisible = true
    },
    handleEdit(row) {
      this.isEdit = true
      this.userForm = { ...row }
      this.dialogVisible = true
    },
    handleSubmit() {
      this.$refs.userForm.validate(valid => {
        if (valid) {
          const request = this.isEdit 
            ? this.$http.put('/api/user', this.userForm)
            : this.$http.post('/api/user', this.userForm)
          request.then(res => {
            if (res.data.code === 200) {
              this.$message.success('保存成功')
              this.dialogVisible = false
              this.loadData()
            }
          })
        }
      })
    },
    handleResetPassword(row) {
      this.$confirm('确定要重置密码为123456吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        row.password = '123456'
        this.$http.put('/api/user', row).then(res => {
          if (res.data.code === 200) {
            this.$message.success('重置成功')
          }
        })
      }).catch(() => {})
    },
    handleToggleStatus(row) {
      row.status = row.status === 1 ? 0 : 1
      this.$http.put('/api/user', row).then(res => {
        if (res.data.code === 200) {
          this.$message.success('操作成功')
        }
      })
    },
    handleDelete(row) {
      this.$confirm('确定要删除该用户吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$http.delete('/api/user/' + row.id).then(res => {
          if (res.data.code === 200) {
            this.$message.success('删除成功')
            this.loadData()
          }
        })
      }).catch(() => {})
    },
    getRoleType(role) {
      const map = { admin: 'danger', project_manager: 'warning', purchaser: 'primary', supplier: 'success' }
      return map[role] || ''
    },
    getRoleText(role) {
      const map = { admin: '管理员', project_manager: '项目经理', purchaser: '采购员', supplier: '供应商' }
      return map[role] || role
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
