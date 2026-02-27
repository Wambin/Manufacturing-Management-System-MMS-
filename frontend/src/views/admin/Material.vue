<template>
  <div class="page-container">
    <el-card>
      <div class="toolbar">
        <el-form :inline="true" class="search-form">
          <el-form-item label="关键词">
            <el-input v-model="searchForm.keyword" placeholder="编码/名称"></el-input>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="loadData">查询</el-button>
            <el-button @click="resetSearch">重置</el-button>
          </el-form-item>
        </el-form>
        <div class="toolbar-right">
          <el-button type="primary" @click="handleAdd">
            <i class="el-icon-plus"></i> 新增物料
          </el-button>
        </div>
      </div>

      <el-table :data="tableData" border stripe>
        <el-table-column prop="materialCode" label="物料编码" width="120"></el-table-column>
        <el-table-column prop="materialName" label="物料名称" width="150"></el-table-column>
        <el-table-column prop="materialType" label="类型" width="100"></el-table-column>
        <el-table-column prop="specification" label="规格型号"></el-table-column>
        <el-table-column prop="material" label="材质" width="100"></el-table-column>
        <el-table-column prop="unit" label="单位" width="80"></el-table-column>
        <el-table-column label="主图" width="100">
          <template slot-scope="scope">
            <img v-if="scope.row.mainImage" :src="scope.row.mainImage" class="material-thumb">
          </template>
        </el-table-column>
        <el-table-column prop="status" label="状态" width="80">
          <template slot-scope="scope">
            <el-tag :type="scope.row.status === 1 ? 'success' : 'danger'">
              {{ scope.row.status === 1 ? '启用' : '禁用' }}
            </el-tag>
          </template>
        </el-table-column>
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

    <el-dialog :title="isEdit ? '编辑物料' : '新增物料'" :visible.sync="dialogVisible" width="700px">
      <el-form :model="materialForm" :rules="rules" ref="materialForm" label-width="100px">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="物料编码" prop="materialCode">
              <el-input v-model="materialForm.materialCode"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="物料名称" prop="materialName">
              <el-input v-model="materialForm.materialName"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="物料类型">
              <el-input v-model="materialForm.materialType"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="规格型号">
              <el-input v-model="materialForm.specification"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="材质">
              <el-input v-model="materialForm.material"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="单位">
              <el-input v-model="materialForm.unit"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="物料主图">
          <el-upload
            action="http://localhost:8080/api/upload"
            :on-success="handleMainImageSuccess"
            :file-list="mainImageList"
            list-type="picture-card"
            :limit="1">
            <i class="el-icon-plus"></i>
          </el-upload>
        </el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="materialForm.status">
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
  name: 'AdminMaterial',
  data() {
    return {
      searchForm: {
        keyword: ''
      },
      tableData: [],
      pagination: {
        current: 1,
        size: 10,
        total: 0
      },
      dialogVisible: false,
      isEdit: false,
      materialForm: {
        id: null,
        materialCode: '',
        materialName: '',
        materialType: '',
        specification: '',
        material: '',
        unit: '',
        mainImage: '',
        status: 1
      },
      mainImageList: [],
      rules: {
        materialCode: [{ required: true, message: '请输入物料编码', trigger: 'blur' }],
        materialName: [{ required: true, message: '请输入物料名称', trigger: 'blur' }]
      }
    }
  },
  mounted() {
    this.loadData()
  },
  methods: {
    loadData() {
      this.$http.get('/api/material/list', {
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
      this.materialForm = {
        id: null,
        materialCode: '',
        materialName: '',
        materialType: '',
        specification: '',
        material: '',
        unit: '',
        mainImage: '',
        status: 1
      }
      this.mainImageList = []
      this.dialogVisible = true
    },
    handleEdit(row) {
      this.isEdit = true
      this.materialForm = { ...row }
      this.mainImageList = this.materialForm.mainImage ? [{ url: this.materialForm.mainImage }] : []
      this.dialogVisible = true
    },
    handleMainImageSuccess(res) {
      if (res.code === 200) {
        this.materialForm.mainImage = res.data.url
      }
    },
    handleSubmit() {
      this.$refs.materialForm.validate(valid => {
        if (valid) {
          const request = this.isEdit 
            ? this.$http.put('/api/material', this.materialForm)
            : this.$http.post('/api/material', this.materialForm)
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
    handleDelete(row) {
      this.$confirm('确定要删除该物料吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$http.delete('/api/material/' + row.id).then(res => {
          if (res.data.code === 200) {
            this.$message.success('删除成功')
            this.loadData()
          }
        })
      }).catch(() => {})
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
.material-thumb {
  width: 60px;
  height: 60px;
  object-fit: cover;
  border-radius: 4px;
}
</style>
