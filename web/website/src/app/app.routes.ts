import { Routes } from '@angular/router';
import { HomeComponent } from './pages/home/home.component';
import { AboutComponent } from './pages/about/about.component';
import { SendAndReceiveComponent } from './pages/send-and-receive/send-and-receive.component';
import { ContactComponent } from './pages/contact/contact.component';
import { CareersComponent } from './pages/careers/careers.component';
import { TermsComponent } from './pages/terms/terms.component';
import { PrivacyComponent } from './pages/privacy/privacy.component';
import { CookiesComponent } from './pages/cookies/cookies.component';
import { ReferAndEarnComponent } from './pages/refer-and-earn/refer-and-earn.component';

export const routes: Routes = [
  { path: '', component: HomeComponent, title: 'Ijevo | Instant & Secure Cross-Border Money Transfers' },
  { path: 'about', component: AboutComponent, title: 'About Us | Ijevo Cross-Border Remittances' },
  { path: 'send-and-receive-money', component: SendAndReceiveComponent, title: 'Send and Receive Money | Ijevo' },
  { path: 'refer-and-earn', component: ReferAndEarnComponent, title: 'Refer and Earn | Give £10, Get £10 | Ijevo' },
  { path: 'contact', component: ContactComponent, title: 'Contact Us | 24/7 Customer Support | Ijevo' },
  { path: 'careers', component: CareersComponent, title: 'Careers at Ijevo | Join Our Mission' },
  { path: 'terms', component: TermsComponent, title: 'Terms and Conditions | Ijevo Ltd' },
  { path: 'privacy', component: PrivacyComponent, title: 'Privacy Policy | Ijevo Ltd' },
  { path: 'cookies', component: CookiesComponent, title: 'Cookie Policy | Ijevo Ltd' },
  { path: '**', redirectTo: '' }
];
