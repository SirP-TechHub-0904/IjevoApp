import { Component, computed, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

interface PayoutCurrency {
  code: string;
  name: string;
  flag: string;
  ratePerGbp: number;
  symbol: string;
}

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './app.html',
  styleUrl: './app.scss'
})
export class App {
  // Mobile Navigation State
  protected readonly isMobileMenuOpen = signal(false);

  // FAQ Accordion State
  protected readonly activeFaqIndex = signal<number | null>(0);

  // Remittance Calculator Signals
  protected readonly sendAmount = signal<number>(500);
  protected readonly sendCurrency = signal<string>('GBP');
  protected readonly receiveCurrency = signal<string>('NGN');

  // Supported Payout Corridors
  protected readonly payoutCurrencies: PayoutCurrency[] = [
    { code: 'NGN', name: 'Nigeria (Naira)', flag: '🇳🇬', ratePerGbp: 1846.00, symbol: '₦' },
    { code: 'KES', name: 'Kenya (Shilling)', flag: '🇰🇪', ratePerGbp: 168.50, symbol: 'KSh' },
    { code: 'GHS', name: 'Ghana (Cedi)', flag: '🇬🇭', ratePerGbp: 19.80, symbol: 'GH₵' },
    { code: 'ARS', name: 'Argentina (Peso)', flag: '🇦🇷', ratePerGbp: 2042.99, symbol: '$' },
    { code: 'PHP', name: 'Philippines (Peso)', flag: '🇵🇭', ratePerGbp: 74.20, symbol: '₱' },
    { code: 'INR', name: 'India (Rupee)', flag: '🇮🇳', ratePerGbp: 108.40, symbol: '₹' }
  ];

  // Selected Currency Details
  protected readonly selectedCurrency = computed(() => {
    const found = this.payoutCurrencies.find(c => c.code === this.receiveCurrency());
    return found || this.payoutCurrencies[0];
  });

  // Current Live Exchange Rate
  protected readonly currentRate = computed(() => {
    return this.selectedCurrency().ratePerGbp;
  });

  // Recipient Payout Calculation
  protected readonly calculatedPayout = computed(() => {
    const total = this.sendAmount() * this.currentRate();
    return total.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
  });

  // Zero Fee Promotion
  protected readonly transferFee = signal<number>(0.00);

  // FAQ List
  protected readonly faqs = [
    {
      question: 'How fast will my recipient receive the transfer?',
      answer: 'Over 92% of transfers to Nigerian bank accounts (Access Bank, GTBank, Zenith) and East African mobile wallets (M-Pesa, MTN MoMo) arrive in under 60 seconds.'
    },
    {
      question: 'What payment methods can I use to pay for my transfer?',
      answer: 'In the UK and Europe, you can pay instantly via Open Banking (Instant Bank Transfer with Monzo, Barclays, Lloyds, etc.), Debit/Credit Cards (Mastercard, Visa), or Apple Pay / Google Pay.'
    },
    {
      question: 'Are there any hidden fees or charges?',
      answer: 'Zero hidden fees. We disclose the exact live exchange rate and guaranteed payout amount before you tap send. There are no surprise deduction fees for your recipient.'
    },
    {
      question: 'Is Ijevo regulated and secure?',
      answer: 'Yes, absolutely. We use bank-grade protection and encryption to keep your money and personal details 100% safe. All transfers comply with strict UK financial regulations (FCA & HMRC).'
    }
  ];

  // Actions
  protected toggleMobileMenu(): void {
    this.isMobileMenuOpen.update(val => !val);
  }

  protected setReceiveCurrency(code: string): void {
    this.receiveCurrency.set(code);
  }

  protected updateSendAmount(val: number): void {
    this.sendAmount.set(val > 0 ? val : 1);
  }

  protected toggleFaq(index: number): void {
    if (this.activeFaqIndex() === index) {
      this.activeFaqIndex.set(null);
    } else {
      this.activeFaqIndex.set(index);
    }
  }
}
