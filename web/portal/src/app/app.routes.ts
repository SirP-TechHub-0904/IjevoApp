import { Routes } from '@angular/router';

export const routes: Routes = [
  {
    path: '',
    redirectTo: 'dashboards/analytics',
    pathMatch: 'full'
  },
  {
    path: 'dashboards/analytics',
    loadComponent: () => import('./pages/analytics/analytics.component').then(m => m.AnalyticsComponent)
  },
  {
    path: '**',
    redirectTo: 'dashboards/analytics'
  }
];
