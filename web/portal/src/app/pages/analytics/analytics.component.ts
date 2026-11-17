import { Component, signal, computed } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

export interface Transaction {
  id: string;
  sender: { name: string; email: string; avatar: string };
  recipient: { name: string; method: string; countryCode: string };
  corridor: string;
  sendAmount: string;
  payoutAmount: string;
  rail: string;
  status: 'Completed' | 'Processing' | 'In Review';
  time: string;
}

@Component({
  selector: 'app-analytics',
  imports: [CommonModule, FormsModule],
  templateUrl: './analytics.component.html',
  styleUrl: './analytics.component.scss'
})
export class AnalyticsComponent {
  // Chart timeframe state
  readonly timeframes: ('24H' | '7D' | '30D' | '90D' | '1Y')[] = ['24H', '7D', '30D', '90D', '1Y'];
  readonly selectedTimeframe = signal<'24H' | '7D' | '30D' | '90D' | '1Y'>('30D');

  // Transaction table filter states
  readonly statusFilter = signal<string>('All');
  readonly searchQuery = signal<string>('');

  // Selected date range text
  readonly dateRange = signal<string>('Nov 01, 2026 - Nov 17, 2026');

  // KPI Metrics
  readonly kpis = [
    {
      title: 'Total Transfer Volume',
      value: '£4,892,450.00',
      change: '+14.2%',
      isPositive: true,
      compareText: 'vs last month',
      targetText: 'Target: £5.2M (94%)',
      icon: 'fa-solid fa-money-bill-trend-up',
      color: 'emerald',
      sparkline: 'M0,35 Q20,10 40,25 T80,15 T120,30 T160,8 T200,5'
    },
    {
      title: 'Completed Transfers',
      value: '28,490',
      change: '+8.7%',
      isPositive: true,
      compareText: '99.4% Success Rate',
      targetText: 'Avg: 950 / day',
      icon: 'fa-solid fa-paper-plane',
      color: 'blue',
      sparkline: 'M0,30 Q25,20 50,28 T100,12 T150,22 T200,8'
    },
    {
      title: 'Active Senders',
      value: '12,840',
      change: '+22.4%',
      isPositive: true,
      compareText: '3,120 New this month',
      targetText: 'Retention: 84.6%',
      icon: 'fa-solid fa-users',
      color: 'purple',
      sparkline: 'M0,38 Q30,30 60,18 T120,25 T170,12 T200,4'
    },
    {
      title: 'Avg Delivery Speed',
      value: '42 Seconds',
      change: '-6s (12.5%)',
      isPositive: true,
      compareText: 'Instant Settlement',
      targetText: 'SLA: < 60s (98.2%)',
      icon: 'fa-solid fa-bolt',
      color: 'amber',
      sparkline: 'M0,10 Q30,22 60,15 T120,28 T170,22 T200,32'
    }
  ];

  // Corridor Distribution
  readonly corridors = [
    { name: 'Nigeria', flag: '🇳🇬', currency: 'NGN', percent: 48, volume: '£2,348,376', count: '13,675 txns', color: '#00D084' },
    { name: 'Ghana', flag: '🇬🇭', currency: 'GHS', percent: 24, volume: '£1,174,188', count: '6,837 txns', color: '#3B82F6' },
    { name: 'Kenya', flag: '🇰🇪', currency: 'KES', percent: 16, volume: '£782,792', count: '4,558 txns', color: '#8B5CF6' },
    { name: 'South Africa', flag: '🇿🇦', currency: 'ZAR', percent: 8, volume: '£391,396', count: '2,280 txns', color: '#F59E0B' },
    { name: 'Others (UG, RW)', flag: '🌍', currency: 'MULTI', percent: 4, volume: '£195,698', count: '1,140 txns', color: '#64748B' }
  ];

  // Clearing Rails Health
  readonly rails = [
    { name: 'UK Faster Payments (FPS)', network: 'Direct Bank Rail', latency: '24ms', uptime: '100%', status: 'Operational', badgeClass: 'badge-success' },
    { name: 'SEPA Instant Settlement', network: 'Eurosystem TIPS', latency: '110ms', uptime: '99.9%', status: 'Operational', badgeClass: 'badge-success' },
    { name: 'Nigeria NIBSS & Paystack', network: 'Naira Instant Rail', latency: '82ms', uptime: '99.8%', status: 'Operational', badgeClass: 'badge-success' },
    { name: 'Kenya M-Pesa Gateway', network: 'Safaricom Direct', latency: '41ms', uptime: '100%', status: 'Operational', badgeClass: 'badge-success' },
    { name: 'Ghana GhIPSS MoMo Rails', network: 'MTN & Vodafone', latency: '95ms', uptime: '99.5%', status: 'Operational', badgeClass: 'badge-success' }
  ];

  // Live FX Spreads
  readonly fxRates = [
    { pair: 'GBP / NGN', interbank: '1,846.00', offered: '1,834.00', spread: '+0.65%', trend: 'up' },
    { pair: 'EUR / NGN', interbank: '1,595.20', offered: '1,585.60', spread: '+0.60%', trend: 'up' },
    { pair: 'USD / NGN', interbank: '1,480.50', offered: '1,473.10', spread: '+0.50%', trend: 'down' },
    { pair: 'GBP / KES', interbank: '168.40', offered: '167.64', spread: '+0.45%', trend: 'up' }
  ];

  // Live Remittance Transactions
  readonly allTransactions: Transaction[] = [
    {
      id: '#TRX-89421',
      sender: { name: 'Chioma Adebayo', email: 'chioma.a@london.co.uk', avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=80&auto=format&fit=crop&q=80' },
      recipient: { name: 'Emeka Adebayo', method: 'Access Bank Plc •••• 9102', countryCode: 'NG' },
      corridor: 'GBP ➔ NGN',
      sendAmount: '£500.00',
      payoutAmount: '₦917,000.00',
      rail: 'NIBSS Instant',
      status: 'Completed',
      time: '2 mins ago'
    },
    {
      id: '#TRX-89420',
      sender: { name: 'David Mensah', email: 'mensah.d@manchester.org', avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=80&auto=format&fit=crop&q=80' },
      recipient: { name: 'Kwame Mensah', method: 'MTN Mobile Money •••• 4421', countryCode: 'GH' },
      corridor: 'GBP ➔ GHS',
      sendAmount: '£250.00',
      payoutAmount: 'GH₵4,150.00',
      rail: 'MTN MoMo Rail',
      status: 'Completed',
      time: '5 mins ago'
    },
    {
      id: '#TRX-89419',
      sender: { name: 'Faith Mwangi', email: 'faith.m@birmingham.ac.uk', avatar: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=80&auto=format&fit=crop&q=80' },
      recipient: { name: 'John Mwangi', method: 'M-Pesa Kenya •••• 6509', countryCode: 'KE' },
      corridor: 'USD ➔ KES',
      sendAmount: '$400.00',
      payoutAmount: 'KSh 52,000.00',
      rail: 'Safaricom M-Pesa',
      status: 'Completed',
      time: '9 mins ago'
    },
    {
      id: '#TRX-89418',
      sender: { name: 'Samuel Okafor', email: 'samuel.ok@dublin.ie', avatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=80&auto=format&fit=crop&q=80' },
      recipient: { name: 'Chinedu Okafor', method: 'GTBank Plc •••• 3318', countryCode: 'NG' },
      corridor: 'EUR ➔ NGN',
      sendAmount: '€350.00',
      payoutAmount: '₦555,000.00',
      rail: 'NIBSS Instant',
      status: 'Processing',
      time: '12 mins ago'
    },
    {
      id: '#TRX-89417',
      sender: { name: 'Grace Osei', email: 'grace.osei@glasgow.gov.uk', avatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=80&auto=format&fit=crop&q=80' },
      recipient: { name: 'Akosua Osei', method: 'Vodafone Cash •••• 8820', countryCode: 'GH' },
      corridor: 'GBP ➔ GHS',
      sendAmount: '£150.00',
      payoutAmount: 'GH₵2,490.00',
      rail: 'GhIPSS Direct',
      status: 'Completed',
      time: '15 mins ago'
    },
    {
      id: '#TRX-89416',
      sender: { name: 'Michael Ndlovu', email: 'michael.n@leeds.ac.uk', avatar: 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=80&auto=format&fit=crop&q=80' },
      recipient: { name: 'Sipho Ndlovu', method: 'Standard Bank •••• 7731', countryCode: 'ZA' },
      corridor: 'GBP ➔ ZAR',
      sendAmount: '£800.00',
      payoutAmount: 'R 18,960.00',
      rail: 'BankServAfrica',
      status: 'In Review',
      time: '21 mins ago'
    },
    {
      id: '#TRX-89415',
      sender: { name: 'Amina Bello', email: 'amina.b@oxford.edu', avatar: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=80&auto=format&fit=crop&q=80' },
      recipient: { name: 'Ibrahim Bello', method: 'Zenith Bank •••• 1145', countryCode: 'NG' },
      corridor: 'GBP ➔ NGN',
      sendAmount: '£1,200.00',
      payoutAmount: '₦2,200,800.00',
      rail: 'NIBSS Instant',
      status: 'Completed',
      time: '28 mins ago'
    },
    {
      id: '#TRX-89414',
      sender: { name: 'Kevin Kamau', email: 'kevin.kamau@paris.fr', avatar: 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=80&auto=format&fit=crop&q=80' },
      recipient: { name: 'Lucy Kamau', method: 'Airtel Money •••• 5590', countryCode: 'KE' },
      corridor: 'EUR ➔ KES',
      sendAmount: '€200.00',
      payoutAmount: 'KSh 27,800.00',
      rail: 'Airtel Money Rail',
      status: 'Completed',
      time: '35 mins ago'
    }
  ];

  // Filtered transactions computed signal
  readonly filteredTransactions = computed(() => {
    const status = this.statusFilter();
    const query = this.searchQuery().toLowerCase().trim();

    return this.allTransactions.filter(item => {
      const matchStatus = status === 'All' || item.status === status;
      const matchQuery = !query || 
        item.id.toLowerCase().includes(query) ||
        item.sender.name.toLowerCase().includes(query) ||
        item.recipient.name.toLowerCase().includes(query) ||
        item.corridor.toLowerCase().includes(query);
      return matchStatus && matchQuery;
    });
  });

  setTimeframe(tf: '24H' | '7D' | '30D' | '90D' | '1Y') {
    this.selectedTimeframe.set(tf);
  }

  setStatus(st: string) {
    this.statusFilter.set(st);
  }
}
