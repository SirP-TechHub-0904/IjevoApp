import { Component, signal, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterOutlet, RouterLink, RouterLinkActive, Router, NavigationEnd, ActivatedRoute } from '@angular/router';
import { Meta, Title } from '@angular/platform-browser';
import { filter } from 'rxjs/operators';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, RouterOutlet, RouterLink, RouterLinkActive],
  templateUrl: './app.html',
  styleUrl: './app.scss'
})
export class App {
  private readonly router = inject(Router);
  private readonly activatedRoute = inject(ActivatedRoute);
  private readonly meta = inject(Meta);
  private readonly titleService = inject(Title);

  // Mobile Navigation State
  protected readonly isMobileMenuOpen = signal(false);

  constructor() {
    this.router.events.pipe(
      filter(event => event instanceof NavigationEnd)
    ).subscribe(() => {
      let route = this.activatedRoute;
      while (route.firstChild) {
        route = route.firstChild;
      }

      route.data.subscribe(data => {
        if (data && data['description']) {
          this.meta.updateTag({ name: 'description', content: data['description'] });
          this.meta.updateTag({ property: 'og:description', content: data['description'] });
          this.meta.updateTag({ name: 'twitter:description', content: data['description'] });
        }

        const pageTitle = this.titleService.getTitle();
        if (pageTitle) {
          this.meta.updateTag({ property: 'og:title', content: pageTitle });
          this.meta.updateTag({ name: 'twitter:title', content: pageTitle });
        }

        if (data && data['canonical']) {
          this.meta.updateTag({ property: 'og:url', content: data['canonical'] });
          this.meta.updateTag({ name: 'twitter:url', content: data['canonical'] });
        }
      });
    });
  }

  protected toggleMobileMenu(): void {
    this.isMobileMenuOpen.update(val => !val);
  }

  protected closeMobileMenu(): void {
    this.isMobileMenuOpen.set(false);
  }
}
