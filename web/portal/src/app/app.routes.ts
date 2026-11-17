import { Routes } from '@angular/router';
import { HomeComponent } from './pages/home/home.component';
import { AboutComponent } from './pages/about/about.component';
import { NigeriaCorridorComponent } from './pages/nigeria/nigeria.component';
import { CorridorsComponent } from './pages/corridors/corridors.component';
import { SecurityComponent } from './pages/security/security.component';
import { HowItWorksComponent } from './pages/how-it-works/how-it-works.component';
import { CareersComponent } from './pages/careers/careers.component';
import { ContactComponent } from './pages/contact/contact.component';
import { TermsComponent } from './pages/terms/terms.component';
import { PrivacyComponent } from './pages/privacy/privacy.component';

export const routes: Routes = [
  { path: '', component: HomeComponent, title: 'Ijevo | Instant & Secure Cross-Border Money Transfers' },
  { path: 'about', component: AboutComponent, title: 'About Us | Ijevo Cross-Border Remittances' },
  { path: 'send-money/nigeria', component: NigeriaCorridorComponent, title: 'Send Money to Nigeria | Fast & Free Bank Transfers | Ijevo' },
  { path: 'corridors', component: CorridorsComponent, title: 'Supported Corridors | Global Payouts | Ijevo' },
  { path: 'security', component: SecurityComponent, title: 'Security & Trust | Bank-Grade Protection | Ijevo' },
  { path: 'how-it-works', component: HowItWorksComponent, title: 'How It Works | 3-Step Simple Transfers | Ijevo' },
  { path: 'careers', component: CareersComponent, title: 'Careers at Ijevo | Join Our Mission' },
  { path: 'contact', component: ContactComponent, title: 'Contact Us | 24/7 Customer Support | Ijevo' },
  { path: 'terms', component: TermsComponent, title: 'Terms of Service | Ijevo Ltd' },
  { path: 'privacy', component: PrivacyComponent, title: 'Privacy Policy | Ijevo Ltd' },
  { path: '**', redirectTo: '' }
];
