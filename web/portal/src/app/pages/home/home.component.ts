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
      answer: 'Over 98% of transfers sent through Ijevo arrive in under 60 seconds. Funds are sent straight to your recipient\'s bank account or mobile wallet without delay.'
    },
    {
      question: 'What payment methods can I use to pay for my transfer?',
      answer: 'In the UK and Europe, you can pay instantly via Open Banking (direct instant transfer with Monzo, Barclays, Lloyds, etc.), Debit Cards (Visa and Mastercard), as well as Apple Pay and Google Pay.'
    },
    {
      question: 'Are there any hidden fees or deduction charges?',
      answer: 'Zero hidden fees. We disclose the exact live exchange rate and guaranteed payout amount before you confirm your transfer. Your recipient receives 100% of the funds with no deductions on their end.'
    },
    {
      question: 'Does my recipient need to have an Ijevo account or app?',
      answer: 'No. Your recipient does not need to download the Ijevo app or register an account. Funds are credited directly into their regular local bank account or mobile money wallet.'
    },
    {
      question: 'How much money can I send per transfer?',
      answer: 'You can send from as little as £1 up to £5,000 per transfer once your identity is confirmed. If you need to make higher transfers or pay for business invoices, our support team can increase your limits swiftly.'
    },
    {
      question: 'What documents do I need to get started?',
      answer: 'You can create your account in under a minute with your mobile phone number. To keep your money safe and increase your transfer limits, we may ask for a quick photo of a valid government ID (such as a passport or driver\'s license).'
    },
    {
      question: 'Which countries can I send money to?',
      answer: 'We currently support instant transfers to Nigeria, Ghana, Kenya, Argentina, Philippines, and India, with additional African and international destinations launching regularly.'
    },
    {
      question: 'Can I track my transfer in real time?',
      answer: 'Yes. You can follow your transfer live right in the app. Both you and your recipient will also receive instant SMS and email confirmations the second the money lands safely.'
    },
    {
      question: 'What happens if I enter the wrong account number or name?',
      answer: 'If the details entered do not match an active account at the destination bank, the transfer is automatically rejected and your money is immediately refunded to your original payment method. Our 24/7 care team is also available to help adjust any details.'
    },
    {
      question: 'How do I contact customer support if I need help?',
      answer: 'Our friendly care team is available 24/7 through live in-app chat, WhatsApp, and email at support@ijevo.com. We average under two minutes response time so you never have to wait.'
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
