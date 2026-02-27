<template>
  <div class="page-container">
    <el-card>
      <div slot="header" class="card-header">
        <span>{{ isEdit ? '编辑项目' : '新增项目' }}</span>
      </div>
      <el-form :model="form" :rules="rules" ref="form" label-width="120px">
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="项目名称" prop="projectName">
              <el-input v-model="form.projectName" placeholder="请输入项目名称"></el-input>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="项目编号" prop="projectNo">
              <el-input v-model="form.projectNo" placeholder="请输入项目编号"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="项目状态" prop="status">
              <el-select v-model="form.status" placeholder="请选择项目状态" style="width: 100%">
                <el-option label="规划中" value="planning"></el-option>
                <el-option label="进行中" value="ongoing"></el-option>
                <el-option label="已完成" value="completed"></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="设备编号">
              <el-input v-model="form.equipmentNo" placeholder="请输入设备编号"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="项目经理">
              <el-input v-model="form.projectManager" placeholder="请输入项目经理"></el-input>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row :gutter="20">
          <el-col :span="12">
            <el-form-item label="开始日期">
              <el-date-picker v-model="form.startDate" type="date" placeholder="选择日期" style="width: 100%" value-format="yyyy-MM-dd"></el-date-picker>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="结束日期">
              <el-date-picker v-model="form.endDate" type="date" placeholder="选择日期" style="width: 100%" value-format="yyyy-MM-dd"></el-date-picker>
            </el-form-item>
          </el-col>
        </el-row>
        <el-form-item label="项目描述">
          <el-input v-model="form.description" type="textarea" :rows="4" placeholder="请输入项目描述"></el-input>
        </el-form-item>

        <el-divider content-position="left">图片上传</el-divider>

        <el-form-item label="设备图片">
          <el-upload
            action="http://localhost:8080/api/upload"
            :on-success="handleEquipmentSuccess"
            :file-list="equipmentFileList"
            list-type="picture-card"
            :limit="5"
            :on-remove="handleEquipmentRemove">
            <i class="el-icon-plus"></i>
          </el-upload>
        </el-form-item>

        <el-form-item label="现场照片">
          <el-upload
            action="http://localhost:8080/api/upload"
            :on-success="handleSiteSuccess"
            :file-list="siteFileList"
            list-type="picture-card"
            :limit="10"
            :on-remove="handleSiteRemove">
            <i class="el-icon-plus"></i>
          </el-upload>
        </el-form-item>

        <el-form-item>
          <el-button type="primary" @click="handleSubmit">保存</el-button>
          <el-button @click="handleCancel">取消</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script>
export default {
  name: 'ProjectEdit',
  data() {
    return {
      isEdit: false,
      form: {
        id: null,
        projectName: '',
        projectNo: '',
        status: 'planning',
        equipmentNo: '',
        projectManager: '',
        startDate: '',
        endDate: '',
        description: '',
        equipmentImages: '[]',
        sitePhotos: '[]'
      },
      rules: {
        projectName: [{ required: true, message: '请输入项目名称', trigger: 'blur' }],
        projectNo: [{ required: true, message: '请输入项目编号', trigger: 'blur' }],
        status: [{ required: true, message: '请选择项目状态', trigger: 'change' }]
      },
      equipmentFileList: [],
      siteFileList: [],
      equipmentImages: [],
      sitePhotos: []
    }
  },
  mounted() {
    const id = this.$route.query.id
    if (id) {
      this.isEdit = true
      this.loadData(id)
    }
  },
  methods: {
    loadData(id) {
      this.$http.get('/api/project/' + id).then(res => {
        if (res.data.code === 200) {
          this.form = res.data.data
          this.equipmentImages = this.parseImages(this.form.equipmentImages)
          this.sitePhotos = this.parseImages(this.form.sitePhotos)
          this.equipmentFileList = this.equipmentImages.map(url => ({ url }))
          this.siteFileList = this.sitePhotos.map(url => ({ url }))
        }
      })
    },
    parseImages(str) {
      if (!str) return []
      try {
        const arr = JSON.parse(str)
        return Array.isArray(arr) ? arr : []
      } catch {
        return []
      }
    },
    handleEquipmentSuccess(res, file, fileList) {
      if (res.code === 200) {
        this.equipmentImages.push(res.data.url)
        this.form.equipmentImages = JSON.stringify(this.equipmentImages)
      }
    },
    handleEquipmentRemove(file, fileList) {
      const index = this.equipmentImages.indexOf(file.url)
      if (index > -1) {
        this.equipmentImages.splice(index, 1)
        this.form.equipmentImages = JSON.stringify(this.equipmentImages)
      }
    },
    handleSiteSuccess(res, file, fileList) {
      if (res.code === 200) {
        this.sitePhotos.push(res.data.url)
        this.form.sitePhotos = JSON.stringify(this.sitePhotos)
      }
    },
    handleSiteRemove(file, fileList) {
      const index = this.sitePhotos.indexOf(file.url)
      if (index > -1) {
        this.sitePhotos.splice(index, 1)
        this.form.sitePhotos = JSON.stringify(this.sitePhotos)
      }
    },
    handleSubmit() {
      this.$refs.form.validate(valid => {
        if (valid) {
          const request = this.isEdit ? this.$http.put('/api/project', this.form) : this.$http.post('/api/project', this.form)
          request.then(res => {
            if (res.data.code === 200) {
              this.$message.success('保存成功')
              this.$router.push('/project/list')
            }
          })
        }
      })
    },
    handleCancel() {
      this.$router.push('/project/list')
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
