<template>
  <div class="page-container">
    <el-card>
      <div slot="header" class="card-header">
        <span>{{ isView ? '查看采购申请' : (isEdit ? '编辑采购申请' : '新增采购申请') }}</span>
      </div>
      <el-form :model="form" :rules="rules" ref="form" label-width="120px">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="项目" prop="projectId">
              <el-select v-model="form.projectId" placeholder="请选择项目" style="width: 100%" :disabled="isView">
                <el-option v-for="item in projectList" :key="item.id" :label="item.projectName" :value="item.id"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="期望到货日" prop="expectDate">
              <el-date-picker v-model="form.expectDate" type="date" placeholder="选择日期" style="width: 100%" value-format="yyyy-MM-dd" :disabled="isView"></el-date-picker>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="优先级" prop="priority">
              <el-radio-group v-model="form.priority" :disabled="isView">
                <el-radio label="low">低</el-radio>
                <el-radio label="normal">普通</el-radio>
                <el-radio label="high">高</el-radio>
              </el-radio-group>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="申请说明">
          <el-input v-model="form.description" type="textarea" :rows="3" placeholder="请输入申请说明" :disabled="isView"></el-input>
        </el-form-item>

        <el-form-item label="上传附件">
          <div v-if="!isView">
            <el-upload
              class="upload-demo"
              action="http://localhost:8080/api/upload"
              :on-success="handleUploadSuccess"
              :on-error="handleUploadError"
              :limit="3"
              :file-list="fileList"
              accept=".pdf,.doc,.docx"
              :auto-upload="true"
            >
              <el-button size="small" type="primary">选择文件</el-button>
              <div slot="tip" class="el-upload__tip">支持上传PDF、Word文档，最多3个文件</div>
            </el-upload>
          </div>
          <div v-if="form.attachments" style="margin-top: 10px;">
            <div v-for="(file, index) in form.attachments.split(',')" :key="index" style="margin-bottom: 5px;">
              <el-button type="text" @click="handleDownload(file)">{{ file.split('/').pop() }}</el-button>
            </div>
          </div>
          <div v-else-if="isView" style="color: #999;">
            无附件
          </div>
        </el-form-item>

        <el-divider content-position="left">物料清单</el-divider>

        <div style="margin-bottom: 10px" v-if="!isView">
          <el-button type="primary" size="small" @click="handleAddMaterial">
            <i class="el-icon-plus"></i> 添加物料
          </el-button>
          <el-button size="small" @click="handleSelectMaterial">
            <i class="el-icon-s-grid"></i> 从物料库选择
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
          <el-table-column label="规格型号" width="120">
            <template slot-scope="scope">
              <el-input v-model="scope.row.specification" placeholder="规格" size="small" :disabled="isView"></el-input>
            </template>
          </el-table-column>
          <el-table-column label="材质" width="100">
            <template slot-scope="scope">
              <el-input v-model="scope.row.material" placeholder="材质" size="small" :disabled="isView"></el-input>
            </template>
          </el-table-column>
          <el-table-column label="数量" width="120">
            <template slot-scope="scope">
              <el-input-number v-model="scope.row.quantity" :min="1" size="small" style="width: 100px" :disabled="isView"></el-input-number>
            </template>
          </el-table-column>
          <el-table-column label="单位" width="80">
            <template slot-scope="scope">
              <el-input v-model="scope.row.unit" placeholder="单位" size="small" :disabled="isView"></el-input>
            </template>
          </el-table-column>
          <el-table-column label="参考图" width="100">
            <template slot-scope="scope">
              <el-upload
                action="http://localhost:8080/api/upload"
                :show-file-list="false"
                :on-success="(res) => handleMaterialImageSuccess(res, scope.row)"
                :disabled="isView">
                <img v-if="scope.row.image" :src="scope.row.image" class="material-image">
                <i v-else class="el-icon-plus material-upload-icon"></i>
              </el-upload>
            </template>
          </el-table-column>
          <el-table-column label="备注" width="120">
            <template slot-scope="scope">
              <el-input v-model="scope.row.remark" placeholder="备注" size="small" :disabled="isView"></el-input>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="80" v-if="!isView">
            <template slot-scope="scope">
              <el-button type="text" size="small" @click="handleRemoveMaterial(scope.$index)" style="color: #f56c6c">删除</el-button>
            </template>
          </el-table-column>
        </el-table>

        <el-form-item v-if="!isView">
          <el-button type="primary" @click="handleSaveDraft">保存草稿</el-button>
          <el-button type="success" @click="handleSubmit">提交审核</el-button>
          <el-button @click="handleCancel">取消</el-button>
        </el-form-item>
        <el-form-item v-else>
          <el-button @click="handleCancel">返回</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <el-dialog title="选择物料" :visible.sync="materialDialogVisible" width="800px">
      <el-table :data="materialList" border @selection-change="handleMaterialSelection">
        <el-table-column type="selection" width="55"></el-table-column>
        <el-table-column prop="materialCode" label="物料编码" width="120"></el-table-column>
        <el-table-column prop="materialName" label="物料名称" width="150"></el-table-column>
        <el-table-column prop="specification" label="规格型号"></el-table-column>
        <el-table-column prop="material" label="材质" width="100"></el-table-column>
        <el-table-column prop="unit" label="单位" width="80"></el-table-column>
      </el-table>
      <div slot="footer">
        <el-button @click="materialDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleConfirmMaterial">确定</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
export default {
  name: 'PurchaseRequestEdit',
  data() {
    return {
      isEdit: false,
      isView: false,
      form: {
        id: null,
        projectId: null,
        applicantId: null,
        expectDate: '',
        priority: 'normal',
        description: '',
        materials: '[]',
        attachments: ''
      },
      fileList: [],
      rules: {
        projectId: [{ required: true, message: '请选择项目', trigger: 'change' }],
        expectDate: [{ required: true, message: '请选择期望到货日', trigger: 'change' }],
        priority: [{ required: true, message: '请选择优先级', trigger: 'change' }]
      },
      projectList: [],
      materials: [],
      materialList: [],
      materialDialogVisible: false,
      selectedMaterials: []
    }
  },
  mounted() {
    this.loadProjects()
    this.loadMaterials()
    const id = this.$route.query.id
    this.isView = this.$route.query.view === 'true'
    if (!id) {
      const user = this.$store.state.user
      this.form.applicantId = user?.id
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
    loadMaterials() {
      this.$http.get('/api/material/all').then(res => {
        if (res.data.code === 200) {
          this.materialList = res.data.data
        }
      })
    },
    loadData(id) {
      this.$http.get('/api/purchase/request/' + id).then(res => {
        if (res.data.code === 200) {
          this.form = res.data.data
          this.materials = this.parseMaterials(this.form.materials)
          // 加载附件信息
          if (this.form.attachments) {
            this.fileList = this.form.attachments.split(',').map(filePath => ({
              name: filePath.split('/').pop(),
              url: filePath
            }))
          }
        }
      })
    },
    parseMaterials(str) {
      if (!str) return []
      try {
        const arr = JSON.parse(str)
        if (Array.isArray(arr)) {
          return arr.map(item => ({
            ...item,
            quantity: Number(item.quantity) || 1
          }))
        }
        return []
      } catch {
        return []
      }
    },
    handleAddMaterial() {
      this.materials.push({
        materialCode: '',
        materialName: '',
        specification: '',
        material: '',
        quantity: 1,
        unit: '',
        image: '',
        remark: ''
      })
    },
    handleSelectMaterial() {
      this.selectedMaterials = []
      this.materialDialogVisible = true
    },
    handleMaterialSelection(selection) {
      this.selectedMaterials = selection
    },
    handleConfirmMaterial() {
      this.selectedMaterials.forEach(m => {
        this.materials.push({
          materialCode: m.materialCode,
          materialName: m.materialName,
          specification: m.specification,
          material: m.material,
          quantity: 1,
          unit: m.unit,
          image: m.mainImage || '',
          remark: ''
        })
      })
      this.materialDialogVisible = false
    },
    handleRemoveMaterial(index) {
      this.materials.splice(index, 1)
    },
    handleMaterialImageSuccess(res, row) {
      if (res.code === 200) {
        row.image = res.data.url
      }
    },
    handleUploadSuccess(response, file, fileList) {
      if (response.code === 200) {
        const filePath = response.data.filePath
        if (this.form.attachments) {
          this.form.attachments += ',' + filePath
        } else {
          this.form.attachments = filePath
        }
        this.$message.success('文件上传成功')
      } else {
        this.$message.error('文件上传失败')
      }
    },
    handleUploadError(err, file, fileList) {
      this.$message.error('文件上传失败')
    },
    handleDownload(filePath) {
      window.open(filePath)
    },
    handleSaveDraft() {
      this.$refs.form.validate(valid => {
        if (valid) {
          const user = this.$store.state.user
          if (user && user.id) {
            this.form.applicantId = user.id
          }
          this.form.materials = JSON.stringify(this.materials)
          this.form.status = 0
          const request = this.isEdit ? this.$http.put('/api/purchase/request', this.form) : this.$http.post('/api/purchase/request', this.form)
          request.then(res => {
            if (res.data.code === 200) {
              this.$message.success('保存成功')
              this.$router.push('/purchase/request/list')
            }
          })
        }
      })
    },
    handleSubmit() {
      this.$refs.form.validate(valid => {
        if (valid) {
          const user = this.$store.state.user
          if (user && user.id) {
            this.form.applicantId = user.id
          }
          this.form.materials = JSON.stringify(this.materials)
          this.form.status = 1 // 直接设置为待审核状态
          const saveRequest = this.isEdit ? this.$http.put('/api/purchase/request', this.form) : this.$http.post('/api/purchase/request', this.form)
          saveRequest.then(res => {
            if (res.data.code === 200) {
              this.$message.success('提交成功')
              this.$router.push('/purchase/request/list')
            }
          })
        }
      })
    },
    handleCancel() {
      this.$router.push('/purchase/request/list')
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
.material-image {
  width: 60px;
  height: 60px;
  object-fit: cover;
  cursor: pointer;
}
.material-upload-icon {
  font-size: 28px;
  color: #8c939d;
  line-height: 60px;
}
</style>
