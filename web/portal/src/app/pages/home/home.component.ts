import { Component, computed, signal } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';

interface PayoutCurrency {
  code: string;
  name: string;
  ratePerGbp: number;
  symbol: string;
}

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterLink],
  templateUrl: './home.component.html',
  styleUrl: './home.component.scss'
})
export class HomeComponent {
  // FAQ Accordion State
  protected readonly activeFaqIndex = signal<number | null>(0);

  // Remittance Calculator Signals
  protected readonly sendAmount = signal<number>(500);
  protected readonly sendCurrency = signal<string>('GBP');
  protected readonly receiveCurrency = signal<string>('NGN');

  // Supported Payout Corridors
  protected readonly payoutCurrencies: PayoutCurrency[] = [
    { code: 'NGN', name: 'Nigerian Naira', ratePerGbp: 1846.00, symbol: '₦' },
    { code: 'KES', name: 'Kenyan Shilling', ratePerGbp: 168.50, symbol: 'KSh' },
    { code: 'GHS', name: 'Ghanaian Cedi', ratePerGbp: 19.80, symbol: 'GH₵' },
    { code: 'ARS', name: 'Argentine Peso', ratePerGbp: 2042.99, symbol: '$' },
    { code: 'PHP', name: 'Philippine Peso', ratePerGbp: 74.20, symbol: '₱' },
    { code: 'INR', name: 'Indian Rupee', ratePerGbp: 108.40, symbol: '₹' }
  ];

  // Selected Currency Details
  protected readonly selectedCurrency = computed(() => {
    const found = this.payoutCurrencies.find(c => c.code === this.receiveCurrency());
    return found || this.payoutCurrencies[0];
  });

  // Computed Exchange Rate
  protected readonly currentRate = computed(() => this.selectedCurrency().ratePerGbp);

  // Computed Payout Total
  protected readonly calculatedPayout = computed(() => {
    const total = this.sendAmount() * this.currentRate();
    return total.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
  });

  // FAQs
  protected readonly faqs = [
    {
      question: 'How fast will my recipient receive the money?',
      answer: 'Over 98% of transfers sent through Ijevo arrive in under 60 seconds. Funds are sent straight to your recipient’s bank account or mobile wallet without delay.'
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
