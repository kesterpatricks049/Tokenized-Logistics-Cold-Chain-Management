# Tokenized Logistics Cold Chain Management

A comprehensive blockchain-based cold chain management system built on the Stacks blockchain using Clarity smart contracts. This system provides end-to-end tracking, monitoring, and compliance management for cold chain logistics operations.

## 🌟 Features

### Core Components

1. **Provider Verification Contract** - Manages cold chain provider registration and verification
2. **Temperature Monitoring Contract** - Real-time temperature tracking and violation detection
3. **Quality Assurance Contract** - Quality inspections and certifications
4. **Compliance Tracking Contract** - Regulatory compliance monitoring and auditing
5. **Loss Prevention Contract** - Incident reporting, risk assessment, and insurance claims

## 🏗️ Architecture

### Smart Contracts

#### Provider Verification (`provider-verification.clar`)
- Provider registration and verification
- Status management (Pending, Verified, Suspended, Revoked)
- Certification tracking
- License validation

#### Temperature Monitoring (`temperature-monitoring.clar`)
- Shipment creation and tracking
- Real-time temperature recording
- Automated violation detection
- Humidity and location tracking

#### Quality Assurance (`quality-assurance.clar`)
- Inspector authorization
- Quality inspections with scoring
- Compliance checks (temperature, packaging, documentation)
- Pass/fail determination

#### Compliance Tracking (`compliance-tracking.clar`)
- Regulatory requirement management
- Auditor authorization
- Compliance record creation
- Violation tracking and corrective actions

#### Loss Prevention (`loss-prevention.clar`)
- Incident reporting with severity levels
- Risk assessment and mitigation
- Insurance claim management
- Loss tracking and prevention measures

## 🚀 Getting Started

### Prerequisites

- Node.js (v16 or higher)
- Stacks CLI
- Clarinet (for local development)

### Installation

1. Clone the repository:
   \`\`\`bash
   git clone <repository-url>
   cd cold-chain-management
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

3. Run tests:
   \`\`\`bash
   npm test
   \`\`\`

### Contract Deployment

1. Configure your Stacks wallet and network settings
2. Deploy contracts in the following order:
    - provider-verification.clar
    - temperature-monitoring.clar
    - quality-assurance.clar
    - compliance-tracking.clar
    - loss-prevention.clar

## 📋 Usage Examples

### Provider Registration

\`\`\`clarity
;; Register a new cold chain provider
(contract-call? .provider-verification register-provider
'SP2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG
"Cold Chain Express"
"CCE-2024-001"
(list "ISO 9001" "HACCP"))
\`\`\`

### Temperature Monitoring

\`\`\`clarity
;; Create a new shipment
(contract-call? .temperature-monitoring create-shipment
"SHIP-2024-001"
'SP2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG
"Frozen Vegetables"
"Farm A"
"Warehouse B"
-1800  ;; -18.00°C
-1500) ;; -15.00°C

;; Record temperature reading
(contract-call? .temperature-monitoring record-temperature
"SHIP-2024-001"
-1600  ;; -16.00°C
u85    ;; 85% humidity
"Transit Point A"
"SENSOR-001")
\`\`\`

### Quality Inspection

\`\`\`clarity
;; Create quality inspection
(contract-call? .quality-assurance create-inspection
"QI-2024-001"
"SHIP-2024-001"
u85    ;; Quality score
true   ;; Temperature compliance
true   ;; Packaging integrity
true   ;; Documentation complete
"All quality standards met")
\`\`\`

## 🧪 Testing

The project includes comprehensive test suites using Vitest:

\`\`\`bash
# Run all tests
npm test

# Run specific test file
npm test provider-verification.test.ts

# Run tests with coverage
npm run test:coverage
\`\`\`

### Test Coverage

- Provider Verification: Registration, verification, status management
- Temperature Monitoring: Shipment creation, temperature recording, violation detection
- Quality Assurance: Inspector management, inspection creation, scoring
- Compliance Tracking: Regulatory management, compliance records, auditing
- Loss Prevention: Incident reporting, risk assessment, insurance claims

## 📊 Data Structures

### Provider Data
\`\`\`clarity
{
name: (string-ascii 100),
license-number: (string-ascii 50),
status: uint,
verification-date: uint,
expiry-date: uint,
certifications: (list 10 (string-ascii 50))
}
\`\`\`

### Shipment Data
\`\`\`clarity
{
provider-id: principal,
product-type: (string-ascii 100),
origin: (string-ascii 100),
destination: (string-ascii 100),
start-time: uint,
end-time: uint,
min-temp-threshold: int,
max-temp-threshold: int,
status: uint
}
\`\`\`

### Temperature Reading
\`\`\`clarity
{
temperature: int,
humidity: uint,
timestamp: uint,
location: (string-ascii 100),
sensor-id: (string-ascii 50)
}
\`\`\`

## 🔒 Security Features

- **Access Control**: Role-based permissions for different operations
- **Data Integrity**: Immutable blockchain storage for audit trails
- **Validation**: Input validation and error handling
- **Authorization**: Multi-signature requirements for critical operations

## 🔧 Configuration

### Environment Variables

\`\`\`bash
# Network configuration
STACKS_NETWORK=testnet
CONTRACT_ADDRESS=ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM

# Temperature thresholds (in celsius * 100)
MIN_TEMP_THRESHOLD=-2000  # -20.00°C
MAX_TEMP_THRESHOLD=800    # 8.00°C

# Quality score thresholds
MIN_QUALITY_SCORE=0
MAX_QUALITY_SCORE=100
PASS_THRESHOLD=70
\`\`\`

## 📈 Monitoring and Analytics

### Key Metrics Tracked

- **Temperature Compliance**: Percentage of readings within acceptable range
- **Quality Scores**: Average quality scores across shipments
- **Incident Frequency**: Number of incidents per time period
- **Provider Performance**: Provider verification and compliance rates
- **Loss Prevention**: Actual vs estimated losses

### Reporting Features

- Real-time temperature monitoring dashboards
- Compliance audit reports
- Quality assurance summaries
- Risk assessment analytics
- Insurance claim tracking

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (\`git checkout -b feature/amazing-feature\`)
3. Commit your changes (\`git commit -m 'Add amazing feature'\`)
4. Push to the branch (\`git push origin feature/amazing-feature\`)
5. Open a Pull Request

### Development Guidelines

- Follow Clarity best practices
- Write comprehensive tests for new features
- Update documentation for API changes
- Ensure all tests pass before submitting PR

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

For support and questions:

- Create an issue in the GitHub repository
- Contact the development team
- Check the documentation wiki

## 🗺️ Roadmap

### Phase 1 (Current)
- ✅ Core contract development
- ✅ Basic testing suite
- ✅ Documentation

### Phase 2 (Planned)
- [ ] Web interface development
- [ ] Mobile app integration
- [ ] Advanced analytics dashboard
- [ ] Multi-chain support

### Phase 3 (Future)
- [ ] AI-powered predictive analytics
- [ ] IoT sensor integration
- [ ] Automated compliance reporting
- [ ] Machine learning for risk assessment

## 🏆 Acknowledgments

- Stacks Foundation for blockchain infrastructure
- Cold chain industry partners for requirements
- Open source community for tools and libraries

---

**Built with ❄️ for the cold chain industry**
\`\`\`

Now let's create the PR details file:
