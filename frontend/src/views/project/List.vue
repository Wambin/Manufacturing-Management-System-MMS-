<template>
  <div class="page-container">
    <el-card>
      <div class="toolbar">
        <el-form :inline="true" class="search-form">
          <el-form-item label="关键词">
            <el-input v-model="searchForm.keyword" placeholder="项目名称/编号"></el-input>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" @click="loadData">查询</el-button>
            <el-button @click="resetSearch">重置</el-button>
          </el-form-item>
        </el-form>
        <div class="toolbar-right">
          <el-button type="primary" @click="handleAdd">
            <i class="el-icon-plus"></i> 新增
          </el-button>
        </div>
      </div>

      <el-table :data="tableData" border stripe>
        <el-table-column prop="projectNo" label="项目编号" width="150"></el-table-column>
        <el-table-column prop="projectName" label="项目名称"></el-table-column>
        <el-table-column prop="status" label="状态" width="100">
          <template slot-scope="scope">
            <el-tag :type="getStatusType(scope.row.status)">{{ getStatusText(scope.row.status) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="equipmentNo" label="设备编号" width="120"></el-table-column>
        <el-table-column prop="projectManager" label="项目经理" width="100"></el-table-column>
        <el-table-column prop="createTime" label="创建时间" width="180"></el-table-column>
        <el-table-column label="操作" width="200" fixed="right">
          <template slot-scope="scope">
            <el-button type="text" size="small" @click="handleEdit(scope.row)">编辑</el-button>
            <el-button type="text" size="small" @click="handleImages(scope.row)">图片</el-button>
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

    <el-dialog title="项目图片" :visible.sync="imagesDialogVisible" width="800px">
      <el-tabs v-if="currentProject">
        <el-tab-pane label="设备图片">
          <div class="image-list">
            <div v-for="(img, index) in getImages(currentProject.equipmentImages)" :key="index" class="image-item">
              <img :src="img" class="preview-image" @click="previewImage(img)">
            </div>
          </div>
        </el-tab-pane>
        <el-tab-pane label="现场照片">
          <div class="image-list">
            <div v-for="(img, index) in getImages(currentProject.sitePhotos)" :key="index" class="image-item">
              <img :src="img" class="preview-image" @click="previewImage(img)">
            </div>
          </div>
        </el-tab-pane>
      </el-tabs>
    </el-dialog>

    <el-image-viewer v-if="previewVisible" :on-close="() => previewVisible = false" :url-list="[previewUrl]"></el-image-viewer>
  </div>
</template>

<script>
export default {
  name: 'ProjectList',
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
      imagesDialogVisible: false,
      currentProject: null,
      previewVisible: false,
      previewUrl: ''
    }
  },
  mounted() {
    this.loadData()
  },
  methods: {
    loadData() {
      this.$http.get('/api/project/list', {
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
      this.$router.push('/project/edit')
    },
    handleEdit(row) {
      this.$router.push('/project/edit?id=' + row.id)
    },
    handleImages(row) {
      this.currentProject = row
      this.imagesDialogVisible = true
    },
    handleDelete(row) {
      this.$confirm('确定要删除该项目吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$http.delete('/api/project/' + row.id).then(res => {
          if (res.data.code === 200) {
            this.$message.success('删除成功')
            this.loadData()
          }
        })
      }).catch(() => {})
    },
    getStatusType(status) {
      const map = { planning: '', ongoing: 'primary', completed: 'success' }
      return map[status] || ''
    },
    getStatusText(status) {
      const map = { planning: '规划中', ongoing: '进行中', completed: '已完成' }
      return map[status] || status
    },
    getImages(str) {
      if (!str) return []
      try {
        const arr = JSON.parse(str)
        return Array.isArray(arr) ? arr : []
      } catch {
        return []
      }
    },
    previewImage(url) {
      this.previewUrl = url
      this.previewVisible = true
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
.image-list {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}
.image-item {
  width: 120px;
  height: 120px;
  border: 1px solid #eee;
  border-radius: 4px;
  overflow: hidden;
}
.preview-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  cursor: pointer;
}
</style>
