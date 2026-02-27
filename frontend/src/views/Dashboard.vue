<template>
  <div class="dashboard">
    <el-row :gutter="20">
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-number">{{ stats.projectCount }}</div>
            <div class="stat-label">项目总数</div>
          </div>
          <i class="el-icon-s-claim stat-icon project"></i>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-number">{{ stats.requestCount }}</div>
            <div class="stat-label">采购申请</div>
          </div>
          <i class="el-icon-s-shop stat-icon request"></i>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-number">{{ stats.orderCount }}</div>
            <div class="stat-label">采购订单</div>
          </div>
          <i class="el-icon-document stat-icon order"></i>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card class="stat-card">
          <div class="stat-content">
            <div class="stat-number">{{ stats.deliveryCount }}</div>
            <div class="stat-label">发货记录</div>
          </div>
          <i class="el-icon-truck stat-icon delivery"></i>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" style="margin-top: 20px;">
      <el-col :span="12">
        <el-card>
          <div slot="header" class="card-header">
            <span>采购申请状态分布</span>
          </div>
          <div ref="requestChart" class="chart-container"></div>
        </el-card>
      </el-col>
      <el-col :span="12">
        <el-card>
          <div slot="header" class="card-header">
            <span>项目状态统计</span>
          </div>
          <div ref="projectChart" class="chart-container"></div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" style="margin-top: 20px;">
      <el-col :span="12">
        <el-card>
          <div slot="header" class="card-header">
            <span>快捷操作</span>
          </div>
          <div class="quick-actions">
            <template v-if="['admin', 'project_manager'].includes(userRole)">
              <el-button type="primary" @click="$router.push('/project/edit')">
                <i class="el-icon-plus"></i> 新建项目
              </el-button>
            </template>
            <template v-if="['admin', 'purchaser'].includes(userRole)">
              <el-button type="success" @click="$router.push('/purchase/request/edit')">
                <i class="el-icon-plus"></i> 新建采购申请
              </el-button>
            </template>
            <template v-if="['admin', 'supplier'].includes(userRole)">
              <el-button type="warning" @click="$router.push('/supplier/order/pending')">
                <i class="el-icon-truck"></i> 待发货订单
              </el-button>
            </template>
          </div>
        </el-card>
      </el-col>
      <el-col :span="12">
        <el-card>
          <div slot="header" class="card-header">
            <span>系统信息</span>
          </div>
          <div class="system-info">
            <p><strong>系统名称：</strong>制造业采购管理系统</p>
            <p><strong>当前用户：</strong>{{ user?.realName || user?.username }}</p>
            <p><strong>当前角色：</strong>{{ roleName }}</p>
            <p><strong>登录时间：</strong>{{ new Date().toLocaleString() }}</p>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import * as echarts from 'echarts'

export default {
  name: 'Dashboard',
  data() {
    return {
      stats: {
        projectCount: 0,
        requestCount: 0,
        orderCount: 0,
        deliveryCount: 0
      },
      charts: {
        requestChart: null,
        projectChart: null
      }
    }
  },
  computed: {
    ...mapGetters(['userRole']),
    user() {
      return this.$store.state.user
    },
    roleName() {
      const roleMap = {
        admin: '管理员',
        project_manager: '项目经理',
        purchaser: '采购员',
        supplier: '供应商'
      }
      return roleMap[this.userRole] || ''
    }
  },
  mounted() {
    this.loadStats()
    this.$nextTick(() => {
      this.initCharts()
    })
    
    // 实时更新数据，每30秒刷新一次
    this.updateInterval = setInterval(() => {
      this.loadStats()
      this.updateCharts()
    }, 30000)
  },
  beforeDestroy() {
    // 清除定时器
    if (this.updateInterval) {
      clearInterval(this.updateInterval)
    }
    
    // 销毁图表实例
    Object.values(this.charts).forEach(chart => {
      if (chart) {
        chart.dispose()
      }
    })
  },
  methods: {
    loadStats() {
      console.log('Loading stats...')
      Promise.all([
        this.$http.get('/api/project/all'),
        this.$http.get('/api/purchase/request/list', { params: { current: 1, size: 100 } }),
        this.$http.get('/api/purchase/order/list', { params: { current: 1, size: 100 } }),
        this.$http.get('/api/delivery/record/list', { params: { current: 1, size: 100 } })
      ]).then(([projRes, reqRes, ordRes, delRes]) => {
        console.log('Project response:', projRes)
        console.log('Request response:', reqRes)
        console.log('Order response:', ordRes)
        console.log('Delivery response:', delRes)
        
        // 基于实际数据计算统计数量，不依赖total字段
        this.stats.projectCount = projRes.data.data ? projRes.data.data.length : 0
        this.stats.requestCount = reqRes.data.data?.records ? reqRes.data.data.records.length : 0
        this.stats.orderCount = ordRes.data.data?.records ? ordRes.data.data.records.length : 0
        this.stats.deliveryCount = delRes.data.data?.records ? delRes.data.data.records.length : 0
        
        console.log('Final stats:', this.stats)
      }).catch((error) => {
        console.error('Error loading stats:', error)
      })
    },
    initCharts() {
      this.initRequestChart()
      this.initProjectChart()
    },
    initRequestChart() {
      if (this.$refs.requestChart) {
        this.charts.requestChart = echarts.init(this.$refs.requestChart)
        this.updateRequestChart()
      }
    },
    initProjectChart() {
      if (this.$refs.projectChart) {
        this.charts.projectChart = echarts.init(this.$refs.projectChart)
        this.updateProjectChart()
      }
    },
    updateCharts() {
      this.updateRequestChart()
      this.updateProjectChart()
    },
    updateRequestChart() {
      if (!this.charts.requestChart) return
      
      const option = {
        tooltip: {
          trigger: 'item',
          formatter: '{a} <br/>{b}: {c} ({d}%)'
        },
        legend: {
          orient: 'vertical',
          left: 'left',
          data: ['草稿', '待审核', '已通过', '已驳回']
        },
        series: [
          {
            name: '采购申请状态',
            type: 'pie',
            radius: '60%',
            center: ['50%', '50%'],
            data: [
              { value: 1, name: '草稿' },
              { value: 2, name: '待审核' },
              { value: 3, name: '已通过' },
              { value: 0, name: '已驳回' }
            ],
            emphasis: {
              itemStyle: {
                shadowBlur: 10,
                shadowOffsetX: 0,
                shadowColor: 'rgba(0, 0, 0, 0.5)'
              }
            }
          }
        ]
      }
      
      this.charts.requestChart.setOption(option)
    },
    updateProjectChart() {
      if (!this.charts.projectChart) return
      
      const option = {
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'shadow'
          }
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true
        },
        xAxis: {
          type: 'category',
          data: ['进行中', '已完成', '已暂停', '已取消']
        },
        yAxis: {
          type: 'value'
        },
        series: [
          {
            name: '项目数量',
            type: 'bar',
            data: [2, 1, 0, 0],
            itemStyle: {
              color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                { offset: 0, color: '#83bff6' },
                { offset: 0.5, color: '#188df0' },
                { offset: 1, color: '#188df0' }
              ])
            },
            emphasis: {
              itemStyle: {
                color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
                  { offset: 0, color: '#2378f7' },
                  { offset: 0.7, color: '#2378f7' },
                  { offset: 1, color: '#83bff6' }
                ])
              }
            }
          }
        ]
      }
      
      this.charts.projectChart.setOption(option)
    }
  }
}
</script>

<style scoped>
.dashboard {
  padding: 10px;
}
.stat-card {
  position: relative;
  overflow: hidden;
}
.stat-content {
  padding: 10px 0;
}
.stat-number {
  font-size: 32px;
  font-weight: bold;
  color: #333;
}
.stat-label {
  font-size: 14px;
  color: #999;
  margin-top: 5px;
}
.stat-icon {
  position: absolute;
  right: 20px;
  top: 50%;
  transform: translateY(-50%);
  font-size: 60px;
  opacity: 0.2;
}
.stat-icon.project { color: #409EFF; }
.stat-icon.request { color: #67C23A; }
.stat-icon.order { color: #E6A23C; }
.stat-icon.delivery { color: #F56C6C; }
.card-header {
  font-weight: bold;
}
.quick-actions {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}
.quick-actions .el-button {
  width: 140px;
}
.system-info p {
  margin: 10px 0;
  color: #666;
}

.chart-container {
  width: 100%;
  height: 300px;
}
</style>
