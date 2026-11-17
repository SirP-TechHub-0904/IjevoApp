import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterLink } from '@angular/router';

interface JobPosting {
  title: string;
  department: string;
  location: string;
  type: string;
  description: string;
}

@Component({
  selector: 'app-careers',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './careers.component.html'
})
export class CareersComponent {
  protected readonly jobs: JobPosting[] = [
    {
      title: 'Senior .NET Backend Engineer',
      department: 'Engineering',
      location: 'London, UK / Hybrid',
      type: 'Full-time',
      description: 'Lead the architecture of our mission-critical transaction settlement engine, distributed ledger services, and banking API integrations.'
    },
    {
      title: 'Staff Mobile Engineer (Flutter)',
      department: 'Mobile Engineering',
      location: 'London / Remote',
      type: 'Full-time',
      description: 'Own the end-to-end user experience of our iOS and Android mobile remittance apps used by thousands of diaspora customers.'
    },
    {
      title: 'Compliance & AML Operations Officer',
      department: 'Risk & Legal',
      location: 'London, UK',
      type: 'Full-time',
      description: 'Ensure strict compliance with UK HMRC MSB and international sanction regimes, manage transaction monitoring, and conduct suspicious activity reporting.'
    },
    {
      title: 'Product Designer (FinTech UI/UX)',
      department: 'Product & Design',
      location: 'Remote (UK / Europe)',
      type: 'Full-time',
      description: 'Craft intuitive, accessible, and delightful mobile-first payment flows that simplify complex financial transactions for global users.'
    },
    {
      title: 'Customer Experience Specialist (24/7 Support)',
      department: 'Customer Operations',
      location: 'Lagos, Nigeria / Hybrid',
      type: 'Full-time (Rotational Shifts)',
      description: 'Provide empathetic, real-time resolution to senders and recipients via live in-app chat, WhatsApp, and email.'
    }
  ];
}
