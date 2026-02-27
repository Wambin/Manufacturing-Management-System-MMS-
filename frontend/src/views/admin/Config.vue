<template>
  <div class="page-container">
    <el-card>
      <div slot="header" class="card-header">
        <span>系统配置</span>
      </div>
      <el-tabs v-model="activeTab">
        <el-tab-pane label="基础配置" name="basic">
          <el-form label-width="150px">
            <el-form-item label="系统名称">
              <el-input v-model="config.systemName" style="width: 400px"></el-input>
            </el-form-item>
            <el-form-item label="系统Logo">
              <el-upload
                action="http://localhost:8080/api/upload"
                :on-success="handleLogoSuccess"
                :show-file-list="false">
                <el-button size="small" type="primary">上传Logo</el-button>
              </el-upload>
            </el-form-item>
            <el-form-item label="登录背景">
              <el-upload
                action="http://localhost:8080/api/upload"
                :on-success="handleBgSuccess"
                :show-file-list="false">
                <el-button size="small" type="primary">上传背景</el-button>
              </el-upload>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="handleSave">保存配置</el-button>
            </el-form-item>
          </el-form>
        </el-form-item>
        </el-tab-pane>
        <el-tab-pane label="邮件配置" name="email">
          <el-form label-width="150px">
            <el-form-item label="SMTP服务器">
              <el-input v-model="config.smtpHost" style="width: 400px"></el-input>
            </el-form-item>
            <el-form-item label="端口">
              <el-input-number v-model="config.smtpPort" style="width: 400px"></el-input-number>
            </el-form-item>
            <el-form-item label="发件人邮箱">
              <el-input v-model="config.senderEmail" style="width: 400px"></el-input>
            </el-form-item>
            <el-form-item label="密码">
              <el-input v-model="config.emailPassword" type="password" style="width: 400px"></el-input>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="handleSave">保存配置</el-button>
            </el-form-item>
          </el-form>
        </el-tab-pane>
        <el-tab-pane label="文件配置" name="file">
          <el-form label-width="150px">
            <el-form-item label="图片最大大小(MB)">
              <el-input-number v-model="config.maxImageSize" style="width: 400px"></el-input-number>
            </el-form-item>
            <el-form-item label="文件最大大小(MB)">
              <el-input-number v-model="config.maxFileSize" style="width: 400px"></el-input-number>
            </el-form-item>
            <el-form-item label="允许格式">
              <el-input v-model="config.allowFormats" style="width: 400px" placeholder="jpg,png,pdf,doc"></el-input>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="handleSave">保存配置</el-button>
            </el-form-item>
          </el-form>
        </el-tab-pane>
      </el-tabs>
    </el-card>
  </div>
</template>

<script>
export default {
  name: 'AdminConfig',
  data() {
    return {
      activeTab: 'basic',
      config: {
        systemName: '制造业采购管理系统',
        systemLogo: '',
        loginBackground: '',
        siteIcon: '',
        smtpHost: '',
        smtpPort: 25,
        senderEmail: '',
        emailPassword: '',
        maxImageSize: 5,
        maxFileSize: 50,
        allowFormats: 'jpg,png,pdf,doc,docx,xls,xlsx'
      }
    }
  },
  methods: {
    handleLogoSuccess(res) {
      if (res.code === 200) {
        this.config.systemLogo = res.data.url
        this.$message.success('Logo上传成功')
      }
    },
    handleBgSuccess(res) {
      if (res.code === 200) {
        this.config.loginBackground = res.data.url
        this.$message.success('背景上传成功')
      }
    },
    handleSave() {
      // 保存到本地存储
      localStorage.setItem('systemConfig', JSON.stringify(this.config))
      this.$message.success('配置保存成功')
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
