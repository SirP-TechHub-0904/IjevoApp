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
  {
    path: '',
    component: HomeComponent,
    title: 'Ijevo | Instant & Secure Cross-Border Money Transfers',
    data: {
      description: 'Send money from the UK and Europe to Nigeria, Ghana, Kenya, and beyond in seconds. Enjoy zero hidden fees, bank-grade protection, and top live exchange rates.',
      canonical: 'https://ijevo.com/'
    }
  },
  {
    path: 'send-and-receive-money',
    component: SendAndReceiveComponent,
    title: 'Send and Receive Money in Seconds | Ijevo',
    data: {
      description: 'Check live exchange rates and send money instantly from GBP, EUR, and USD to Nigeria (NGN), Ghana (GHS), and Kenya (KES). Direct bank deposits and mobile wallets.',
      canonical: 'https://ijevo.com/send-and-receive-money'
    }
  },
  {
    path: 'refer-and-earn',
    component: ReferAndEarnComponent,
    title: 'Refer and Earn | Give £10, Get £10 | Ijevo',
    data: {
      description: 'Invite your friends and family to send money with Ijevo. When they make their first transfer, they get £10 fee discount and you receive £10 cash bonus.',
      canonical: 'https://ijevo.com/refer-and-earn'
    }
  },
  {
    path: 'about',
    component: AboutComponent,
    title: 'About Us | Our Mission & Global Remittance Highway | Ijevo',
    data: {
      description: 'Learn about Ijevo, our mission to build a modern, transparent remittance bridge connecting diaspora families in the UK and Europe with home.',
      canonical: 'https://ijevo.com/about'
    }
  },
  {
    path: 'contact',
    component: ContactComponent,
    title: 'Contact Us | 24/7 Dedicated Support | Ijevo',
    data: {
      description: 'Reach Ijevo dedicated 24/7 customer support via in-app live chat, WhatsApp, or email at support@ijevo.com. We are here to help anytime.',
      canonical: 'https://ijevo.com/contact'
    }
  },
  {
    path: 'careers',
    component: CareersComponent,
    title: 'Careers at Ijevo | Join Our Mission',
    data: {
      description: 'Build the future of cross-border financial services with Ijevo. Explore our open engineering, product, and compliance roles.',
      canonical: 'https://ijevo.com/careers'
    }
  },
  {
    path: 'terms',
    component: TermsComponent,
    title: 'Terms and Conditions | Ijevo Ltd',
    data: {
      description: 'Read the official terms and conditions for using the Ijevo international money transfer platform and mobile applications.',
      canonical: 'https://ijevo.com/terms'
    }
  },
  {
    path: 'privacy',
    component: PrivacyComponent,
    title: 'Privacy Policy | Ijevo Ltd',
    data: {
      description: 'Understand how Ijevo protects your personal privacy and secures your financial transaction data in full compliance with GDPR.',
      canonical: 'https://ijevo.com/privacy'
    }
  },
  {
    path: 'cookies',
    component: CookiesComponent,
    title: 'Cookie Policy | Ijevo Ltd',
    data: {
      description: 'Information about how cookies and tracking technologies are used on the Ijevo website to deliver a secure and personalized remittance experience.',
      canonical: 'https://ijevo.com/cookies'
    }
  },
  { path: '**', redirectTo: '' }
];
