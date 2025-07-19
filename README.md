# UPI-Transaction-2024
Data-Driven User Targeting and Profit Optimization

* A comprehensive analysis of over 250,000 UPI transactions from 2024 using Python, aimed at uncovering trends in transaction types, age demographics, regional behaviors, bank preferences, and merchant category spending

# UPI Transactions 2024 – Exploratory Data Analysis 

*  Data Loading and Initial Exploration

  import pandas as pd

# Load the dataset
data = pd.read_csv('upi_transactions_2024.csv')
data.head(2)

# Load specific columns for analysis
df = pd.read_csv('upi_transactions_2024.csv', usecols=[
    'timestamp','transaction type','merchant_category','amount (INR)',
    'sender_age_group','receiver_age_group','sender_state',
    'sender_bank','receiver_bank','day_of_week'
])

df.head(20)

# Data Inspection & Cleaning

# Check missing values
df.isnull().mean() * 100

# Basic info

 df.info()

 df.columns

 df.dtypes
 
 df.describe()

# Convert timestamp

df['timestamp'] = pd.to_datetime(df['timestamp'])

# Check shape
df.shape

# Age group & type distributions

df['sender_age_group'].value_counts()

df['receiver_age_group'].value_counts()

df['transaction type'].value_counts()

# Replace age group labels

df['receiver_age_group'] = df['receiver_age_group'].replace({
    '18-25': 'A', '26-35': 'B', '36-45': 'C', '46-55': 'D', '56+': 'E'
})


df['sender_age_group'] = df['sender_age_group'].replace({
    '18-25': 'A', '26-35': 'B', '36-45': 'C', '46-55': 'D', '56+': 'E'
})


 # Exploratory Analysis

 df['merchant_category'].value_counts()
 
df['sender_state'].value_counts()

df['sender_bank'].value_counts()

df['receiver_bank'].value_counts()

df['day_of_week'].value_counts()


# Sender State vs Sender Age Group 

import matplotlib.pyplot as plt

import seaborn as sns

plt.figure(figsize=(7, 6))

sns.countplot(data=df, x='sender_state', hue='sender_age_group')

plt.title('Transaction Count by Sender State and Age Group')

plt.xlabel('Sender State')

plt.ylabel('Number of Transactions')

plt.xticks(rotation=45)

plt.tight_layout()

plt.show()


 #  Monthly Total Amount by Merchant Category 

 df['year_month'] = df['timestamp'].dt.to_period('M').astype(str)
 
monthly_amount = df.groupby(['year_month', 'merchant_category'])['amount (INR)'].sum().reset_index()

plt.figure(figsize=(14,7))

sns.lineplot(data=monthly_amount, x='year_month', y='amount (INR)', hue='merchant_category', marker='o')

plt.xticks(rotation=45)

plt.xlabel('Month')

plt.ylabel('Total Amount (INR)')

plt.legend(title='Merchant Category', bbox_to_anchor=(1.05, 1), loc='upper left')

plt.tight_layout()

plt.show()

# Heatmap: Merchant Category vs Month 

pivot_table = monthly_amount.pivot(index='merchant_category', columns='year_month', values='amount (INR)')

plt.figure(figsize=(12,5))

sns.heatmap(pivot_table, annot=True, fmt=".0f", cmap='YlOrRd')

plt.xlabel('Month')

plt.ylabel('Merchant Category')

plt.xticks(rotation=45)

plt.show()


# Merchant Category vs Receiver Age Group

sns.countplot(data=df, x='merchant_category', hue='receiver_age_group')

plt.xticks(rotation=45)

plt.tight_layout()

plt.show()

cross_tab = pd.crosstab(df['merchant_category'], df['receiver_age_group'])

plt.figure(figsize=(10,6))

sns.heatmap(cross_tab, annot=True, fmt='d', cmap='YlGnBu')

plt.title('Heatmap of Merchant Category vs Receiver Age Group')

plt.ylabel('Merchant Category')

plt.xlabel('Receiver Age Group')

plt.show()

# Merchant Category vs Sender Age Group 

sns.countplot(data=df, x='merchant_category', hue='sender_age_group')

plt.xticks(rotation=45)

plt.tight_layout()

plt.show()

cross_tab = pd.crosstab(df['merchant_category'], df['sender_age_group'])

plt.figure(figsize=(10,6))

sns.heatmap(cross_tab, annot=True, fmt='d', cmap='YlGnBu')

plt.title('Heatmap of Merchant Category vs Sender Age Group')

plt.ylabel('Merchant Category')

plt.xlabel('Sender Age Group')

plt.show()

# Total Amount by Merchant Category 

sns.barplot(x='merchant_category', y='amount (INR)', data=df, color='orange', errorbar=None)

plt.xticks(rotation=45)

plt.tight_layout()

plt.show()

# Age Group and Transaction Type Distribution 

sns.countplot(x='receiver_age_group', data=df, color='orange')

sns.countplot(x='transaction type', data=df, color='orange', width=0.35)

# Pie chart for transaction type
transaction_counts = df['transaction type'].value_counts()

plt.figure(figsize=(5, 4))

plt.pie(transaction_counts, labels=transaction_counts.index, autopct='%1.1f%%', startangle=140, colors=plt.cm.tab20.colors)

plt.axis('equal')

plt.tight_layout()

plt.show()

# Amount Distribution by Sender Bank

amount_by_sender_bank = df.groupby('sender_bank')['amount (INR)'].sum()

plt.pie(amount_by_sender_bank, labels=amount_by_sender_bank.index, autopct='%1.1f%%', startangle=90)

plt.axis('equal')

plt.show()

# Amount Distribution by Receiver Bank

amount_by_receiver_bank = df.groupby('receiver_bank')['amount (INR)'].sum()

plt.pie(amount_by_receiver_bank, labels=amount_by_receiver_bank.index, autopct='%1.1f%%', startangle=90)

plt.axis('equal')

plt.show()

#  Monthly Transaction Count 

df['month'] = df['timestamp'].dt.strftime('%B')


month_order = ['January', 'February', 'March', 'April', 'May', 'June',
               'July', 'August', 'September', 'October', 'November', 'December']

               
sns.countplot(x='month', data=df, order=month_order, color='orange')

plt.title("Monthly Transaction Count")

plt.xticks(rotation=45)

plt.tight_layout()

plt.show()







































 




























  




























 

