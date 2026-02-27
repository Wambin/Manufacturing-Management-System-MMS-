<template>
  <div class="login-container">
    <div class="login-box">
      <div class="login-title">制造业采购管理系统</div>
      <el-form :model="loginForm" :rules="rules" ref="loginForm" label-width="80px">
        <el-form-item label="用户名" prop="username">
          <el-input v-model="loginForm.username" placeholder="请输入用户名"></el-input>
        </el-form-item>
        <el-form-item label="密码" prop="password">
          <el-input v-model="loginForm.password" type="password" placeholder="请输入密码" @keyup.enter.native="handleLogin"></el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleLogin" style="width: 100%">登录</el-button>
        </el-form-item>
      </el-form>
      <div class="tips">
        <p>测试账号：</p>
        <p>管理员: admin / 123456</p>
        <p>项目经理: pm / 123456</p>
        <p>采购员: purchaser / 123456</p>
        <p>供应商: supplier1 / 123456</p>
      </div>
    </div>
  </div>
</template>

<script>
import { mapActions } from 'vuex'

export default {
  name: 'Login',
  data() {
    return {
      loginForm: {
        username: '',
        password: ''
      },
      rules: {
        username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
        password: [{ required: true, message: '请输入密码', trigger: 'blur' }]
      },
      loginBackground: 'http://localhost:8082/VCG211558468717.webp'
    }
  },
  mounted() {
    this.loadLoginBackground()
    this.updateBackgroundStyle()
  },
  methods: {
    ...mapActions(['login']),
    loadLoginBackground() {
      const config = localStorage.getItem('systemConfig')
      if (config) {
        try {
          const systemConfig = JSON.parse(config)
          if (systemConfig.loginBackground) {
            this.loginBackground = systemConfig.loginBackground
            this.updateBackgroundStyle()
          }
        } catch (e) {
          console.error('Failed to parse system config:', e)
        }
      }
    },
    updateBackgroundStyle() {
      const container = document.querySelector('.login-container')
      if (container) {
        container.style.background = `url('${this.loginBackground}') no-repeat center center fixed`
        container.style.backgroundSize = 'cover'
      }
    },
    handleLogin() {
      this.$refs.loginForm.validate(valid => {
        if (valid) {
          this.$http.post('/api/auth/login', this.loginForm).then(res => {
            if (res.data.code === 200) {
              const { user, token } = res.data.data
              this.login({ user, token })
              this.$message.success('登录成功')
              this.$router.push('/')
            } else {
              this.$message.error(res.data.message)
            }
          }).catch(() => {
            this.$message.error('登录失败，请检查网络')
          })
        }
      })
    }
  }
}
</script>

<style>
/* 全局样式确保html和body占满屏幕 */
html, body {
  height: 100%;
  margin: 0;
  padding: 0;
}

#app {
  height: 100%;
}
</style>

<style scoped>
.login-container {
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  position: relative;
}

/* 添加半透明遮罩增强文字可读性 */
.login-container::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.4);
  z-index: 1;
}

.login-box {
  width: 500px;
  padding: 50px;
  background: rgba(255, 255, 255, 0.7);
  border-radius: 15px;
  box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.3);
  backdrop-filter: blur(10px);
  position: relative;
  z-index: 2;
}

.login-title {
  text-align: center;
  font-size: 24px;
  font-weight: bold;
  color: #333;
  margin-bottom: 30px;
}

.tips {
  margin-top: 20px;
  font-size: 12px;
  color: #666;
}

.tips p {
  margin: 5px 0;
}
</style>
