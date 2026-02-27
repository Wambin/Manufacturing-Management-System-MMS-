<template>
  <el-container class="layout-container">
    <el-aside width="200px">
      <div class="logo">
        <div class="logo-image" v-if="systemConfig.systemLogo">
          <img :src="systemConfig.systemLogo" alt="Logo">
        </div>
        <span class="logo-text">采购管理系统</span>
      </div>
      <el-menu
        :default-active="activeMenu"
        router
        background-color="#304156"
        text-color="#bfcbd9"
        active-text-color="#409EFF">
        <el-menu-item index="/dashboard">
          <i class="el-icon-s-home"></i>
          <span>首页</span>
        </el-menu-item>

        <template v-if="['admin', 'project_manager'].includes(userRole)">
          <el-submenu index="project">
            <template slot="title">
              <i class="el-icon-s-claim"></i>
              <span>项目管理</span>
            </template>
            <el-menu-item index="/project/list">项目列表</el-menu-item>
          </el-submenu>
        </template>

        <template v-if="['admin', 'purchaser'].includes(userRole)">
          <el-submenu index="purchase">
            <template slot="title">
              <i class="el-icon-shopping-cart-full"></i>
              <span>采购管理</span>
            </template>
            <el-menu-item index="/purchase/request/list">采购申请</el-menu-item>
            <el-menu-item index="/purchase/order/list">采购订单</el-menu-item>
            <el-menu-item index="/purchase/delivery/list">发货记录</el-menu-item>
          </el-submenu>
        </template>

        <template v-if="['admin', 'project_manager'].includes(userRole)">
          <el-submenu index="audit">
            <template slot="title">
              <i class="el-icon-s-check"></i>
              <span>审核管理</span>
            </template>
            <el-menu-item index="/purchase/request/confirm">采购申请审核</el-menu-item>
          </el-submenu>
        </template>

        <template v-if="['admin', 'supplier'].includes(userRole)">
          <el-submenu index="supplier">
            <template slot="title">
              <i class="el-icon-truck"></i>
              <span>发货管理</span>
            </template>
            <el-menu-item index="/supplier/order/pending">待履约订单</el-menu-item>
            <el-menu-item index="/supplier/delivery/list">发货记录</el-menu-item>
          </el-submenu>
        </template>

        <template v-if="userRole === 'admin'">
          <el-submenu index="system">
            <template slot="title">
              <i class="el-icon-setting"></i>
              <span>系统管理</span>
            </template>
            <el-menu-item index="/admin/user">用户管理</el-menu-item>
            <el-menu-item index="/admin/material">物料管理</el-menu-item>
            <el-menu-item index="/admin/supplier">供应商管理</el-menu-item>
            <el-menu-item index="/admin/config">系统配置</el-menu-item>
          </el-submenu>
        </template>
      </el-menu>
    </el-aside>

    <el-container>
      <el-header>
        <div class="header-left">
          <span class="welcome">欢迎，{{ user?.realName || user?.username }}</span>
          <el-tag :type="roleTagType">{{ roleName }}</el-tag>
        </div>
        <div class="header-right">
          <el-button type="text" @click="handleLogout">退出登录</el-button>
        </div>
      </el-header>

      <el-main>
        <router-view/>
      </el-main>
    </el-container>
  </el-container>
</template>

<script>
import { mapGetters, mapActions } from 'vuex'

export default {
  name: 'Layout',
  data() {
    return {
      systemConfig: {
        systemLogo: ''
      }
    }
  },
  computed: {
    ...mapGetters(['userRole']),
    user() {
      return this.$store.state.user
    },
    activeMenu() {
      return this.$route.path
    },
    roleName() {
      const roleMap = {
        admin: '管理员',
        project_manager: '项目经理',
        purchaser: '采购员',
        supplier: '供应商'
      }
      return roleMap[this.userRole] || ''
    },
    roleTagType() {
      const typeMap = {
        admin: 'danger',
        project_manager: 'warning',
        purchaser: 'primary',
        supplier: 'success'
      }
      return typeMap[this.userRole] || ''
    }
  },
  mounted() {
    this.loadSystemConfig()
  },
  methods: {
    ...mapActions(['logout']),
    handleLogout() {
      this.$confirm('确定要退出登录吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.logout()
        this.$router.push('/login')
      }).catch(() => {})
    },
    loadSystemConfig() {
      // 从本地存储获取系统配置
      const config = localStorage.getItem('systemConfig')
      if (config) {
        try {
          this.systemConfig = JSON.parse(config)
        } catch (e) {
          console.error('Failed to parse system config:', e)
        }
      }
    }
  }
}
</script>

<style scoped>
.layout-container {
  height: 100%;
}
.el-aside {
  background-color: #304156;
  overflow-x: hidden;
}
.logo {
  height: 60px;
  line-height: 60px;
  text-align: center;
  color: white;
  font-size: 16px;
  font-weight: bold;
  background-color: #263445;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 10px;
}

.logo-image {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  overflow: hidden;
}

.logo-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.logo-text {
  font-size: 16px;
  font-weight: bold;
}
.el-header {
  background-color: white;
  box-shadow: 0 1px 4px rgba(0, 21, 41, 0.08);
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 20px;
}
.header-left {
  display: flex;
  align-items: center;
  gap: 10px;
}
.welcome {
  font-size: 16px;
  color: #333;
}
.el-main {
  background-color: #f0f2f5;
  padding: 20px;
}
</style>
