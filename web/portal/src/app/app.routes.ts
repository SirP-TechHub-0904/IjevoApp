import { Routes } from '@angular/router';

export const routes: Routes = [
  {
    path: '',
    redirectTo: 'dashboards/analytics',
    pathMatch: 'full'
  },
  // Dashboards
  {
    path: 'dashboards/analytics',
    loadComponent: () => import('./pages/analytics/analytics.component').then(m => m.AnalyticsComponent)
  },
  {
    path: 'dashboards/overview',
    loadComponent: () => import('./pages/overview/overview.component').then(m => m.OverviewComponent)
  },
  {
    path: 'dashboards/liquidity',
    loadComponent: () => import('./pages/liquidity/liquidity.component').then(m => m.LiquidityComponent)
  },

  // Remittance Ops
  {
    path: 'remittance/transactions',
    loadComponent: () => import('./pages/transactions/transactions.component').then(m => m.TransactionsComponent)
  },
  {
    path: 'remittance/batches',
    loadComponent: () => import('./pages/batches/batches.component').then(m => m.BatchesComponent)
  },
  {
    path: 'remittance/exceptions',
    loadComponent: () => import('./pages/exceptions/exceptions.component').then(m => m.ExceptionsComponent)
  },
  {
    path: 'remittance/corridors',
    loadComponent: () => import('./pages/corridors/corridors.component').then(m => m.CorridorsComponent)
  },
  {
    path: 'remittance/rails',
    loadComponent: () => import('./pages/rails/rails.component').then(m => m.RailsComponent)
  },

  // Compliance & Risk
  {
    path: 'compliance/kyc',
    loadComponent: () => import('./pages/kyc/kyc.component').then(m => m.KycComponent)
  },
  {
    path: 'compliance/aml',
    loadComponent: () => import('./pages/aml/aml.component').then(m => m.AmlComponent)
  },

  // Customers
  {
    path: 'customers/senders',
    loadComponent: () => import('./pages/senders/senders.component').then(m => m.SendersComponent)
  },
  {
    path: 'customers/beneficiaries',
    loadComponent: () => import('./pages/beneficiaries/beneficiaries.component').then(m => m.BeneficiariesComponent)
  },
  {
    path: 'customers/referrals',
    loadComponent: () => import('./pages/referrals/referrals.component').then(m => m.ReferralsComponent)
  },

  // Settings
  {
    path: 'settings/api-keys',
    loadComponent: () => import('./pages/api-keys/api-keys.component').then(m => m.ApiKeysComponent)
  },
  {
    path: 'settings/audit-logs',
    loadComponent: () => import('./pages/audit-logs/audit-logs.component').then(m => m.AuditLogsComponent)
  },
  {
    path: 'settings/configuration',
    loadComponent: () => import('./pages/configuration/configuration.component').then(m => m.ConfigurationComponent)
  },

  {
    path: '**',
    redirectTo: 'dashboards/analytics'
  }
];
