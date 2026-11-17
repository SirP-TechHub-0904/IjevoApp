import { Component, signal, HostListener, effect } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterOutlet, RouterLink, RouterLinkActive } from '@angular/router';

@Component({
  selector: 'app-root',
  imports: [CommonModule, RouterOutlet, RouterLink, RouterLinkActive],
  templateUrl: './app.html',
  styleUrl: './app.scss'
})
export class App {
  readonly isSidebarCollapsed = signal<boolean>(false);
  readonly isDarkMode = signal<boolean>(false);
  readonly isNotificationOpen = signal<boolean>(false);
  readonly isProfileOpen = signal<boolean>(false);
  readonly isMobileMenuOpen = signal<boolean>(false);

  // Active navigation section
  readonly openSubmenus = signal<Record<string, boolean>>({
    dashboards: true,
    remittance: true,
    compliance: false,
    customers: false
  });

  // Recent notifications mock data
  readonly notifications = [
    {
      id: 1,
      title: 'High Volume Surge',
      message: 'UK ➔ Nigeria corridor exceeded £1.2M in the last 2 hours.',
      time: '10m ago',
      icon: 'fa-solid fa-arrow-trend-up',
      type: 'success'
    },
    {
      id: 2,
      title: 'AML Flag Raised',
      message: 'Transaction #TRX-89416 flagged for PEP threshold review.',
      time: '24m ago',
      icon: 'fa-solid fa-triangle-exclamation',
      type: 'warning'
    },
    {
      id: 3,
      title: 'Rail Latency Optimized',
      message: 'NIBSS instant settlement latency dropped to 82ms.',
      time: '1h ago',
      icon: 'fa-solid fa-bolt',
      type: 'info'
    },
    {
      id: 4,
      title: 'Liquidity Rebalanced',
      message: '€500,000 SEPA treasury buffer allocated to Euronet vault.',
      time: '3h ago',
      icon: 'fa-solid fa-building-columns',
      type: 'primary'
    }
  ];

  constructor() {
    // Sync dark mode class to document body
    effect(() => {
      if (this.isDarkMode()) {
        document.body.classList.add('dark-mode');
      } else {
        document.body.classList.remove('dark-mode');
      }
    });
  }

  toggleSidebar() {
    this.isSidebarCollapsed.update(val => !val);
  }

  toggleMobileMenu() {
    this.isMobileMenuOpen.update(val => !val);
  }

  toggleTheme() {
    this.isDarkMode.update(val => !val);
  }

  toggleNotifications(event?: Event) {
    if (event) event.stopPropagation();
    this.isNotificationOpen.update(val => !val);
    this.isProfileOpen.set(false);
  }

  toggleProfile(event?: Event) {
    if (event) event.stopPropagation();
    this.isProfileOpen.update(val => !val);
    this.isNotificationOpen.set(false);
  }

  toggleSubmenu(menuKey: string) {
    this.openSubmenus.update(prev => ({
      ...prev,
      [menuKey]: !prev[menuKey]
    }));
  }

  @HostListener('document:click')
  closeDropdowns() {
    this.isNotificationOpen.set(false);
    this.isProfileOpen.set(false);
  }

  @HostListener('window:keydown', ['$event'])
  handleKeyDown(event: KeyboardEvent) {
    if ((event.ctrlKey || event.metaKey) && event.key === 'k') {
      event.preventDefault();
      // quick search shortcut
    }
  }
}
