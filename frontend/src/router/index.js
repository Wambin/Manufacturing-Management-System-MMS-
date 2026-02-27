import Vue from 'vue'
import VueRouter from 'vue-router'
import store from '@/store'

Vue.use(VueRouter)

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/Login.vue')
  },
  {
    path: '/',
    name: 'Layout',
    component: () => import('@/views/Layout.vue'),
    redirect: '/dashboard',
    children: [
      {
        path: 'dashboard',
        name: 'Dashboard',
        component: () => import('@/views/Dashboard.vue')
      },
      {
        path: 'project/list',
        name: 'ProjectList',
        component: () => import('@/views/project/List.vue')
      },
      {
        path: 'project/edit',
        name: 'ProjectEdit',
        component: () => import('@/views/project/Edit.vue')
      },
      {
        path: 'purchase/request/list',
        name: 'PurchaseRequestList',
        component: () => import('@/views/purchase/RequestList.vue')
      },
      {
        path: 'purchase/request/edit',
        name: 'PurchaseRequestEdit',
        component: () => import('@/views/purchase/RequestEdit.vue')
      },
      {
        path: 'purchase/request/confirm',
        name: 'PurchaseRequestConfirm',
        component: () => import('@/views/purchase/RequestConfirm.vue')
      },
      {
        path: 'purchase/order/list',
        name: 'PurchaseOrderList',
        component: () => import('@/views/purchase/OrderList.vue')
      },
      {
        path: 'purchase/order/edit',
        name: 'PurchaseOrderEdit',
        component: () => import('@/views/purchase/OrderEdit.vue')
      },
      {
        path: 'purchase/delivery/list',
        name: 'PurchaseDeliveryList',
        component: () => import('@/views/purchase/DeliveryList.vue')
      },
      {
        path: 'purchase/delivery/view',
        name: 'PurchaseDeliveryView',
        component: () => import('@/views/purchase/DeliveryView.vue')
      },
      {
        path: 'supplier/order/pending',
        name: 'SupplierOrderPending',
        component: () => import('@/views/supplier/OrderPending.vue')
      },
      {
        path: 'supplier/delivery/edit',
        name: 'SupplierDeliveryEdit',
        component: () => import('@/views/supplier/DeliveryEdit.vue')
      },
      {
        path: 'supplier/delivery/list',
        name: 'SupplierDeliveryList',
        component: () => import('@/views/supplier/DeliveryList.vue')
      },
      {
        path: 'admin/user',
        name: 'AdminUser',
        component: () => import('@/views/admin/User.vue')
      },
      {
        path: 'admin/material',
        name: 'AdminMaterial',
        component: () => import('@/views/admin/Material.vue')
      },
      {
        path: 'admin/config',
        name: 'AdminConfig',
        component: () => import('@/views/admin/Config.vue')
      },
      {
        path: 'admin/supplier',
        name: 'AdminSupplier',
        component: () => import('@/views/admin/Supplier.vue')
      }
    ]
  }
]

const router = new VueRouter({
  mode: 'history',
  routes
})

router.beforeEach((to, from, next) => {
  if (to.path !== '/login' && !store.getters.isLoggedIn) {
    next('/login')
  } else if (to.path === '/login' && store.getters.isLoggedIn) {
    next('/')
  } else {
    next()
  }
})

export default router
