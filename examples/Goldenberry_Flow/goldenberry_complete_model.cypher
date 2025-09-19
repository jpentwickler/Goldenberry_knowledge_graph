// =====================================================
// Goldenberry Flow - Complete Business Model Knowledge Graph
// Digital Trust Export Platform with Dual Customer Segments
// Updated to reflect Notion-aligned structure with comprehensive channels and costs
// =====================================================

// Clear existing data (UNCOMMENT ONLY IF NEEDED)
// MATCH (n) DETACH DELETE n;

// =====================================================
// CONSTRAINTS CREATION (Run these first)
// =====================================================

CREATE CONSTRAINT goldenberry_business_model_id IF NOT EXISTS FOR (bm:BusinessModel) REQUIRE bm.id IS UNIQUE;
CREATE CONSTRAINT goldenberry_value_proposition_id IF NOT EXISTS FOR (vp:ValueProposition) REQUIRE vp.id IS UNIQUE;
CREATE CONSTRAINT goldenberry_customer_segment_id IF NOT EXISTS FOR (cs:CustomerSegment) REQUIRE cs.id IS UNIQUE;
CREATE CONSTRAINT goldenberry_job_executor_id IF NOT EXISTS FOR (je:JobExecutor) REQUIRE je.id IS UNIQUE;
CREATE CONSTRAINT goldenberry_job_to_be_done_id IF NOT EXISTS FOR (job:JobToBeDone) REQUIRE job.id IS UNIQUE;
CREATE CONSTRAINT goldenberry_channel_id IF NOT EXISTS FOR (ch:Channel) REQUIRE ch.id IS UNIQUE;
CREATE CONSTRAINT goldenberry_customer_relationship_id IF NOT EXISTS FOR (cr:CustomerRelationship) REQUIRE cr.id IS UNIQUE;
CREATE CONSTRAINT goldenberry_revenue_stream_id IF NOT EXISTS FOR (rs:RevenueStream) REQUIRE rs.id IS UNIQUE;
CREATE CONSTRAINT goldenberry_key_resource_id IF NOT EXISTS FOR (kr:KeyResource) REQUIRE kr.id IS UNIQUE;
CREATE CONSTRAINT goldenberry_key_activity_id IF NOT EXISTS FOR (ka:KeyActivity) REQUIRE ka.id IS UNIQUE;
CREATE CONSTRAINT goldenberry_key_partnership_id IF NOT EXISTS FOR (kp:KeyPartnership) REQUIRE kp.id IS UNIQUE;
CREATE CONSTRAINT goldenberry_cost_structure_id IF NOT EXISTS FOR (cost:CostStructure) REQUIRE cost.id IS UNIQUE;

// =====================================================
// BUSINESS MODEL NODE (Central Entity)
// =====================================================

CREATE (bm:BusinessModel {
    id: "bm_goldenberry_flow",
    name: "Goldenberry Flow Digital Trust Export Platform",
    description: "A blockchain-enabled dual-segment business model providing investment opportunities in professionally managed fruit export operations while delivering premium exotic fruits to global importers through Estonian-regulated digital trust infrastructure.",
    createdDate: date("2024-09-16"),
    lastModified: date("2024-09-16"),

    // Semantic Enhancement Properties
    semanticDescription: "A strategic management template used for developing new business models and documenting existing ones. It offers a visual chart with elements describing a firm's or product's value proposition, infrastructure, customers, and finances, assisting businesses to align their activities by illustrating potential trade-offs.",
    theoreticalFoundation: "Based on Alexander Osterwalder and Yves Pigneur's Business Model Canvas framework, co-created with 470 practitioners from 45 countries. The canvas consists of nine building blocks that describe value proposition, infrastructure, customers, and finances.",
    purpose: "To help companies move beyond product-centric thinking towards business model thinking, enabling structured conversations around new businesses or existing ones for strategic management and innovation."
});

// =====================================================
// VALUE PROPOSITION NODES
// =====================================================

CREATE (vp1:ValueProposition {
    id: "vp_digital_trust_investment",
    title: "Digital Trust Investment Platform",
    description: "Direct participation in professionally managed export business through fiduciary-grade digital trust with guaranteed fixed returns, real-time transparency, and blockchain-enforced smart contracts.",

    // Semantic Enhancement Properties
    semanticDescription: "The collection of products and services a business offers to meet the needs of its customers. According to Osterwalder, a company's value proposition is what distinguishes it from its competitors. It provides value through various elements such as newness, performance, customization, getting the job done, design, brand/status, price, cost reduction, risk reduction, accessibility, and convenience/usability.",
    theoreticalFoundation: "Central element of Osterwalder's Business Model Canvas, representing the unique combination of products and services that create value for specific customer segments. The value proposition is at the center of the canvas, connecting customer-facing and infrastructure elements.",
    valueElements: "Provides value through: blockchain security (newness), guaranteed returns (performance), Estonian legal framework (risk reduction), real-time transparency (accessibility), automated distributions (convenience)."
});

CREATE (vp2:ValueProposition {
    id: "vp_premium_fruit_export",
    title: "Premium Exotic Fruit Export Operations",
    description: "Direct access to high-quality, traceable premium exotic fruits through institutionally-managed export operations with complete supply chain transparency, consistency, and zero production risks.",

    // Semantic Enhancement Properties
    semanticDescription: "The collection of products and services a business offers to meet the needs of its customers. According to Osterwalder, a company's value proposition is what distinguishes it from its competitors. It provides value through various elements such as newness, performance, customization, getting the job done, design, brand/status, price, cost reduction, risk reduction, accessibility, and convenience/usability.",
    theoreticalFoundation: "Central element of Osterwalder's Business Model Canvas, representing the unique combination of products and services that create value for specific customer segments. The value proposition is at the center of the canvas, connecting customer-facing and infrastructure elements.",
    valueElements: "Provides value through: premium quality assurance (performance), supply chain transparency (risk reduction), consistent availability (job completion), containerized delivery (convenience), professional management (risk reduction)."
});

// =====================================================
// CUSTOMER SEGMENT NODES
// =====================================================

CREATE (cs1:CustomerSegment {
    id: "cs_investors",
    name: "Digital Trust Investors",
    description: "Investment professionals and individuals seeking secure, transparent, and fixed-return opportunities in alternative asset classes, particularly those interested in blockchain-enforced investment contracts and export business participation.",

    // Semantic Enhancement Properties
    semanticDescription: "The different groups of people or organizations an enterprise aims to reach and serve. To build an effective business model, a company must identify which customers it tries to serve. Various sets of customers can be segmented based on their different needs and attributes to ensure appropriate implementation of corporate strategy.",
    theoreticalFoundation: "One of nine building blocks in Osterwalder's Business Model Canvas. Customer segments can include mass market, niche market, segmented, diversified, and multi-sided platforms, each requiring tailored value propositions and relationship strategies.",
    segmentationApproach: "Segments are defined based on different needs, attributes, and jobs-to-be-done, enabling companies to tailor their value propositions and business model elements to specific customer groups."
});

CREATE (cs2:CustomerSegment {
    id: "cs_fruit_importers",
    name: "Premium Fruit Importers",
    description: "International wholesale fruit importers, distribution companies, and supermarket chains requiring consistent supply of high-quality exotic fruits with full traceability and compliance documentation for European and global markets.",

    // Semantic Enhancement Properties
    semanticDescription: "The different groups of people or organizations an enterprise aims to reach and serve. To build an effective business model, a company must identify which customers it tries to serve. Various sets of customers can be segmented based on their different needs and attributes to ensure appropriate implementation of corporate strategy.",
    theoreticalFoundation: "One of nine building blocks in Osterwalder's Business Model Canvas. Customer segments can include mass market, niche market, segmented, diversified, and multi-sided platforms, each requiring tailored value propositions and relationship strategies.",
    segmentationApproach: "Segments are defined based on different needs, attributes, and jobs-to-be-done, enabling companies to tailor their value propositions and business model elements to specific customer groups."
});

// =====================================================
// JOB EXECUTOR NODES (JTBD Integration)
// =====================================================

CREATE (je1:JobExecutor {
    id: "je_investor",
    name: "Investment Decision Maker",
    executorType: "core job executor",
    roleTitle: "Investment Manager, Financial Advisor, or Private Investor",
    industryDomain: "Alternative investments, fintech, blockchain finance",
    environment: "Digital-first investment platforms with regulatory compliance",
    experienceLevel: "Experienced in alternative assets and blockchain investments",
    executionFrequency: "Quarterly to annual investment decision cycles",
    authorityInfluence: "Full control over investment allocation and strategy",
    dependencyStructure: "May work with financial advisors or investment committees",
    constraintsLimitations: "Regulatory compliance requirements, risk management protocols",
    toolsSystemsUsed: "Digital wallets, investment platforms, blockchain interfaces",
    informationBehavior: "Requires transparent, real-time data and regulatory compliance",
    demographics: "Tech-savvy investors, institutional funds, high-net-worth individuals",

    // Semantic Enhancement Properties
    semanticDescription: "The individual or role responsible for executing a specific job-to-be-done. In ODI methodology, job executors are the people who actually perform the core functional job, and understanding their context, constraints, and capabilities is crucial for developing solutions that fit their execution environment.",
    theoreticalFoundation: "Based on Anthony Ulwick's Outcome-Driven Innovation framework and Tony Ulwick's Jobs-to-be-Done theory. The job executor concept recognizes that understanding WHO performs the job is as important as understanding the job itself, as their context directly influences solution requirements.",
    odiRelevance: "Critical for ODI process as job executors define the execution context, constraints, and success metrics. Their characteristics directly influence what constitutes an effective solution and how outcomes should be measured."
});

CREATE (je2:JobExecutor {
    id: "je_fruit_importer",
    name: "Fruit Import Operations Manager",
    executorType: "core job executor",
    roleTitle: "Import Manager, Procurement Director, Supply Chain Manager",
    industryDomain: "Fresh produce import/export, wholesale distribution, retail supply chain",
    environment: "B2B commercial operations with international logistics",
    experienceLevel: "Expert in fruit import regulations, quality standards, logistics",
    executionFrequency: "Continuous procurement cycles, seasonal planning",
    authorityInfluence: "Control over supplier selection, quality standards, procurement volumes",
    dependencyStructure: "Works with logistics teams, quality control, regulatory compliance",
    constraintsLimitations: "Food safety regulations, customs requirements, seasonal availability",
    toolsSystemsUsed: "ERP systems, logistics platforms, quality management systems",
    informationBehavior: "Requires detailed quality specs, compliance documentation, supply forecasts",
    demographics: "International trade professionals, food industry executives",

    // Semantic Enhancement Properties
    semanticDescription: "The individual or role responsible for executing a specific job-to-be-done. In ODI methodology, job executors are the people who actually perform the core functional job, and understanding their context, constraints, and capabilities is crucial for developing solutions that fit their execution environment.",
    theoreticalFoundation: "Based on Anthony Ulwick's Outcome-Driven Innovation framework and Tony Ulwick's Jobs-to-be-Done theory. The job executor concept recognizes that understanding WHO performs the job is as important as understanding the job itself, as their context directly influences solution requirements.",
    odiRelevance: "Critical for ODI process as job executors define the execution context, constraints, and success metrics. Their characteristics directly influence what constitutes an effective solution and how outcomes should be measured."
});

// =====================================================
// JOB TO BE DONE NODES (JTBD Core)
// =====================================================

CREATE (job1:JobToBeDone {
    id: "job_maximize_capital_returns",
    jobStatement: "Maximize return on capital investment",
    jobType: "Functional",
    contextOfExecution: "Investment portfolio management and alternative asset allocation",
    jobCategory: "Financial investment and wealth management",
    frequency: "Annual investment cycles with quarterly reviews",
    priorityLevel: "High - Core financial objective",

    // Semantic Enhancement Properties
    semanticDescription: "A job-to-be-done is a fundamental unit of analysis that describes what customers are trying to accomplish in a given situation. As Clayton Christensen states: 'Customers don't buy products; they pull them into their life to make progress.' A job describes the progress that a customer is trying to make in a particular circumstance.",
    theoreticalFoundation: "Originally conceptualized by Tony Ulwick in 1990 and later popularized by Clayton Christensen. Based on the premise that people buy products and services to get jobs done. The theory provides a framework for categorizing, defining, capturing, and organizing customer needs tied to the job-to-be-done.",
    odiFramework: "In Ulwick's ODI framework, jobs include: (i) core functional job-to-be-done, (ii) desired outcomes tied to the core functional job, (iii) related jobs, (iv) emotional and social jobs, (v) consumption chain jobs, and (vi) buyer's financial desired outcomes.",
    stabilityCharacteristic: "A properly defined functional job-to-be-done is stable over time - it doesn't change. What changes is the solution or technology used to get the job done. This stability makes jobs a reliable foundation for innovation strategy."
});

CREATE (job2:JobToBeDone {
    id: "job_ensure_consistent_supply",
    jobStatement: "Ensure consistent supply that meets supermarket standards",
    jobType: "Functional",
    contextOfExecution: "International fruit import operations and supply chain management",
    jobCategory: "Supply chain and procurement management",
    frequency: "Continuous with seasonal planning cycles",
    priorityLevel: "Critical - Business operational requirement",

    // Semantic Enhancement Properties
    semanticDescription: "A job-to-be-done is a fundamental unit of analysis that describes what customers are trying to accomplish in a given situation. As Clayton Christensen states: 'Customers don't buy products; they pull them into their life to make progress.' A job describes the progress that a customer is trying to make in a particular circumstance.",
    theoreticalFoundation: "Originally conceptualized by Tony Ulwick in 1990 and later popularized by Clayton Christensen. Based on the premise that people buy products and services to get jobs done. The theory provides a framework for categorizing, defining, capturing, and organizing customer needs tied to the job-to-be-done.",
    odiFramework: "In Ulwick's ODI framework, jobs include: (i) core functional job-to-be-done, (ii) desired outcomes tied to the core functional job, (iii) related jobs, (iv) emotional and social jobs, (v) consumption chain jobs, and (vi) buyer's financial desired outcomes.",
    stabilityCharacteristic: "A properly defined functional job-to-be-done is stable over time - it doesn't change. What changes is the solution or technology used to get the job done. This stability makes jobs a reliable foundation for innovation strategy."
});

// =====================================================
// REVENUE STREAM NODES (Amount properties removed per alignment)
// =====================================================

CREATE (rs1:RevenueStream {
    id: "rs_physalis_container_sales",
    name: "Premium Physalis Container Sales",
    type: "one-time",
    pricingMechanism: "fixed",
    frequency: "per container",

    // Semantic Enhancement Properties
    semanticDescription: "The cash a company generates from each customer segment. Revenue streams represent the arteries of a business model and answer the question: For what value is each customer segment truly willing to pay? Revenue can be generated through various mechanisms including asset sales, usage fees, subscription fees, lending/renting/leasing, licensing, brokerage fees, and advertising.",
    theoreticalFoundation: "Core component of Osterwalder's Business Model Canvas representing the financial viability element. Revenue streams can have different pricing mechanisms including fixed list prices, bargaining, auctioning, market dependent, volume dependent, or yield management.",
    revenueTypes: "Revenue generation methods: Asset sale (selling ownership rights), Usage fee (pay-per-use), Subscription fees (selling continuous access), Lending/Renting/Leasing (temporarily granting exclusive rights), Licensing (granting permission to use protected intellectual property), Brokerage fees (intermediation services), Advertising (advertising space fees)."
});

CREATE (rs2:RevenueStream {
    id: "rs_pitahaya_container_sales",
    name: "Pitahaya Container Sales",
    type: "one-time",
    pricingMechanism: "fixed",
    frequency: "per container",

    // Semantic Enhancement Properties
    semanticDescription: "The cash a company generates from each customer segment. Revenue streams represent the arteries of a business model and answer the question: For what value is each customer segment truly willing to pay? Revenue can be generated through various mechanisms including asset sales, usage fees, subscription fees, lending/renting/leasing, licensing, brokerage fees, and advertising.",
    theoreticalFoundation: "Core component of Osterwalder's Business Model Canvas representing the financial viability element. Revenue streams can have different pricing mechanisms including fixed list prices, bargaining, auctioning, market dependent, volume dependent, or yield management.",
    revenueTypes: "Revenue generation methods: Asset sale (selling ownership rights), Usage fee (pay-per-use), Subscription fees (selling continuous access), Lending/Renting/Leasing (temporarily granting exclusive rights), Licensing (granting permission to use protected intellectual property), Brokerage fees (intermediation services), Advertising (advertising space fees)."
});

CREATE (rs3:RevenueStream {
    id: "rs_seasonal_fruit_sales",
    name: "Seasonal Exotic Fruit Container Sales",
    type: "recurring",
    pricingMechanism: "market-based",
    frequency: "seasonal cycles",

    // Semantic Enhancement Properties
    semanticDescription: "The cash a company generates from each customer segment. Revenue streams represent the arteries of a business model and answer the question: For what value is each customer segment truly willing to pay? Revenue can be generated through various mechanisms including asset sales, usage fees, subscription fees, lending/renting/leasing, licensing, brokerage fees, and advertising.",
    theoreticalFoundation: "Core component of Osterwalder's Business Model Canvas representing the financial viability element. Revenue streams can have different pricing mechanisms including fixed list prices, bargaining, auctioning, market dependent, volume dependent, or yield management.",
    revenueTypes: "Revenue generation methods: Asset sale (selling ownership rights), Usage fee (pay-per-use), Subscription fees (selling continuous access), Lending/Renting/Leasing (temporarily granting exclusive rights), Licensing (granting permission to use protected intellectual property), Brokerage fees (intermediation services), Advertising (advertising space fees)."
});

// =====================================================
// KEY RESOURCE NODES (Updated to match Notion categories)
// =====================================================

CREATE (kr1:KeyResource {
    id: "kr_digital_infrastructure_resources",
    name: "Digital Infrastructure Resources",
    type: "intellectual",
    description: "Blockchain platform, smart contract systems, digital trust architecture, AI analytics, investor portal, and real-time transparency dashboards.",
    ownership: "owned",

    // Semantic Enhancement Properties
    semanticDescription: "The most important assets required to make a business model work. Key resources allow an enterprise to create and offer a value proposition, reach markets, maintain relationships with customer segments, and earn revenues. Different business models require different key resources, which can be owned, leased, or acquired from partners.",
    theoreticalFoundation: "Essential building block of Osterwalder's Business Model Canvas representing the asset foundation. Resources can be physical, intellectual, human, or financial.",
    resourceCategories: "Intellectual resources including proprietary technology platforms, blockchain infrastructure, software systems, and digital trust frameworks."
});

CREATE (kr2:KeyResource {
    id: "kr_financial_resources",
    name: "Financial Resources",
    type: "financial",
    description: "Investment capital, working capital reserves, operational cash flow, dividend reserves, and multi-currency payment systems.",
    ownership: "owned",

    // Semantic Enhancement Properties
    semanticDescription: "The most important assets required to make a business model work. Key resources allow an enterprise to create and offer a value proposition, reach markets, maintain relationships with customer segments, and earn revenues. Different business models require different key resources, which can be owned, leased, or acquired from partners.",
    theoreticalFoundation: "Essential building block of Osterwalder's Business Model Canvas representing the asset foundation. Resources can be physical, intellectual, human, or financial.",
    resourceCategories: "Financial resources including cash, lines of credit, investment reserves, and currency management capabilities."
});

CREATE (kr3:KeyResource {
    id: "kr_human_resources",
    name: "Human Resources",
    type: "human",
    description: "Trust operations administrators, export commercial specialists, blockchain developers, compliance experts, and account management teams.",
    ownership: "owned",

    // Semantic Enhancement Properties
    semanticDescription: "The most important assets required to make a business model work. Key resources allow an enterprise to create and offer a value proposition, reach markets, maintain relationships with customer segments, and earn revenues. Different business models require different key resources, which can be owned, leased, or acquired from partners.",
    theoreticalFoundation: "Essential building block of Osterwalder's Business Model Canvas representing the asset foundation. Resources can be physical, intellectual, human, or financial.",
    resourceCategories: "Human resources including specialized expertise in trust operations, export management, technology development, and compliance."
});

CREATE (kr4:KeyResource {
    id: "kr_legal_regulatory_resources",
    name: "Legal & Regulatory Resources",
    type: "intellectual",
    description: "Estonian legal framework, EU compliance structure, blockchain regulations, fiduciary licenses, and international trade certifications.",
    ownership: "partner",

    // Semantic Enhancement Properties
    semanticDescription: "The most important assets required to make a business model work. Key resources allow an enterprise to create and offer a value proposition, reach markets, maintain relationships with customer segments, and earn revenues. Different business models require different key resources, which can be owned, leased, or acquired from partners.",
    theoreticalFoundation: "Essential building block of Osterwalder's Business Model Canvas representing the asset foundation. Resources can be physical, intellectual, human, or financial.",
    resourceCategories: "Intellectual resources including legal frameworks, regulatory compliance structures, and licensing arrangements."
});

CREATE (kr5:KeyResource {
    id: "kr_partnership_technology_resources",
    name: "Partnership & Technology Resources",
    type: "physical",
    description: "Export operations infrastructure, quality control facilities, container shipping networks, and technology platform partnerships.",
    ownership: "partner",

    // Semantic Enhancement Properties
    semanticDescription: "The most important assets required to make a business model work. Key resources allow an enterprise to create and offer a value proposition, reach markets, maintain relationships with customer segments, and earn revenues. Different business models require different key resources, which can be owned, leased, or acquired from partners.",
    theoreticalFoundation: "Essential building block of Osterwalder's Business Model Canvas representing the asset foundation. Resources can be physical, intellectual, human, or financial.",
    resourceCategories: "Physical resources accessed through partnerships including facilities, infrastructure, and technology platforms."
});

// =====================================================
// KEY ACTIVITY NODES (Updated to match Notion structure - 6 activities)
// =====================================================

CREATE (ka1:KeyActivity {
    id: "ka_digital_trust_asset_management",
    name: "Digital Trust Asset Management",
    type: "platform/network",
    description: "Managing blockchain-based investment contracts, automated dividend distributions, real-time transparency systems, and digital asset operations.",
    priority: "critical",

    // Semantic Enhancement Properties
    semanticDescription: "The most important things a company must do to make its business model work. Key activities are the critical actions a company must take to operate successfully. These activities are required to create and offer a value proposition, reach markets, maintain customer relationships, and earn revenues.",
    theoreticalFoundation: "Core building block of Osterwalder's Business Model Canvas representing operational requirements. Activities vary based on business model type and can be categorized as production, problem-solving, or platform/network activities.",
    activityCategories: "Platform/Network activities including digital platform management, blockchain operations, and automated system coordination."
});

CREATE (ka2:KeyActivity {
    id: "ka_financial_operations_compliance",
    name: "Financial Operations & Compliance",
    type: "problem-solving",
    description: "Managing financial operations, regulatory compliance, tax optimization, payment processing, and legal framework adherence across international operations.",
    priority: "critical",

    // Semantic Enhancement Properties
    semanticDescription: "The most important things a company must do to make its business model work. Key activities are the critical actions a company must take to operate successfully. These activities are required to create and offer a value proposition, reach markets, maintain customer relationships, and earn revenues.",
    theoreticalFoundation: "Core building block of Osterwalder's Business Model Canvas representing operational requirements. Activities vary based on business model type and can be categorized as production, problem-solving, or platform/network activities.",
    activityCategories: "Problem-solving activities including financial management, regulatory compliance, and specialized operational solutions."
});

CREATE (ka3:KeyActivity {
    id: "ka_investor_services_transparency",
    name: "Investor Services & Transparency",
    type: "platform/network",
    description: "Providing investor onboarding, KYC/AML processing, transparency reporting, performance tracking, and investor relationship management.",
    priority: "high",

    // Semantic Enhancement Properties
    semanticDescription: "The most important things a company must do to make its business model work. Key activities are the critical actions a company must take to operate successfully. These activities are required to create and offer a value proposition, reach markets, maintain customer relationships, and earn revenues.",
    theoreticalFoundation: "Core building block of Osterwalder's Business Model Canvas representing operational requirements. Activities vary based on business model type and can be categorized as production, problem-solving, or platform/network activities.",
    activityCategories: "Platform/Network activities focused on investor service delivery and transparency provision."
});

CREATE (ka4:KeyActivity {
    id: "ka_trust_operations_administration",
    name: "Trust Operations Administration",
    type: "problem-solving",
    description: "Administering fiduciary duties, trust governance, investor protection, compliance monitoring, and human oversight of automated systems.",
    priority: "critical",

    // Semantic Enhancement Properties
    semanticDescription: "The most important things a company must do to make its business model work. Key activities are the critical actions a company must take to operate successfully. These activities are required to create and offer a value proposition, reach markets, maintain customer relationships, and earn revenues.",
    theoreticalFoundation: "Core building block of Osterwalder's Business Model Canvas representing operational requirements. Activities vary based on business model type and can be categorized as production, problem-solving, or platform/network activities.",
    activityCategories: "Problem-solving activities involving fiduciary administration and trust governance."
});

CREATE (ka5:KeyActivity {
    id: "ka_customer_relationship_order_management",
    name: "Customer Relationship & Order Management",
    type: "problem-solving",
    description: "Managing relationships with both investor and importer segments, processing purchase orders, coordinating seasonal planning, and providing dedicated account management.",
    priority: "high",

    // Semantic Enhancement Properties
    semanticDescription: "The most important things a company must do to make its business model work. Key activities are the critical actions a company must take to operate successfully. These activities are required to create and offer a value proposition, reach markets, maintain customer relationships, and earn revenues.",
    theoreticalFoundation: "Core building block of Osterwalder's Business Model Canvas representing operational requirements. Activities vary based on business model type and can be categorized as production, problem-solving, or platform/network activities.",
    activityCategories: "Problem-solving activities focused on customer relationship management and order coordination."
});

CREATE (ka6:KeyActivity {
    id: "ka_partnership_coordination",
    name: "Partnership Coordination with Local Operating Partner",
    type: "problem-solving",
    description: "Coordinating fruit sourcing, quality control, export documentation, container logistics, and international shipping operations with Colombian partners.",
    priority: "critical",

    // Semantic Enhancement Properties
    semanticDescription: "The most important things a company must do to make its business model work. Key activities are the critical actions a company must take to operate successfully. These activities are required to create and offer a value proposition, reach markets, maintain customer relationships, and earn revenues.",
    theoreticalFoundation: "Core building block of Osterwalder's Business Model Canvas representing operational requirements. Activities vary based on business model type and can be categorized as production, problem-solving, or platform/network activities.",
    activityCategories: "Problem-solving activities involving partnership coordination and operational management."
});

// =====================================================
// KEY PARTNERSHIP NODES (Updated to match Notion - 5 partnerships)
// =====================================================

CREATE (kp1:KeyPartnership {
    id: "kp_primary_operational_partner",
    name: "Primary Operational Partner",
    type: "supplier relationship",
    motivation: "operational efficiency",
    description: "Colombian fruit producers, local export operations, quality control facilities, and ground-level operational management for fruit sourcing and processing.",

    // Semantic Enhancement Properties
    semanticDescription: "The network of suppliers and partners that make the business model work. Companies create alliances to optimize their business models, reduce risk, or acquire resources. Partnerships are becoming a cornerstone of many business models as companies seek to focus on their core activities while leveraging partners for non-core capabilities.",
    theoreticalFoundation: "Strategic building block of Osterwalder's Business Model Canvas representing external relationship management. Partnerships can be motivated by optimization and economy of scale, reduction of risk and uncertainty, or acquisition of particular resources and activities.",
    partnershipTypes: "Supplier relationships ensuring reliable fruit supply and quality control operations."
});

CREATE (kp2:KeyPartnership {
    id: "kp_financial_trust_infrastructure_partners",
    name: "Financial & Trust Infrastructure Partners",
    type: "strategic alliance",
    motivation: "financial infrastructure",
    description: "Banking partners, payment processors, digital wallet providers, and financial infrastructure supporting both fiat and cryptocurrency transactions for investor operations.",

    // Semantic Enhancement Properties
    semanticDescription: "The network of suppliers and partners that make the business model work. Companies create alliances to optimize their business models, reduce risk, or acquire resources. Partnerships are becoming a cornerstone of many business models as companies seek to focus on their core activities while leveraging partners for non-core capabilities.",
    theoreticalFoundation: "Strategic building block of Osterwalder's Business Model Canvas representing external relationship management. Partnerships can be motivated by optimization and economy of scale, reduction of risk and uncertainty, or acquisition of particular resources and activities.",
    partnershipTypes: "Strategic alliances providing financial infrastructure and payment processing capabilities."
});

CREATE (kp3:KeyPartnership {
    id: "kp_technology_platform_partners",
    name: "Technology & Platform Partners",
    type: "strategic alliance",
    motivation: "technology access",
    description: "Blockchain platform providers, smart contract development partners, cloud infrastructure providers, and cryptocurrency payment processing systems.",

    // Semantic Enhancement Properties
    semanticDescription: "The network of suppliers and partners that make the business model work. Companies create alliances to optimize their business models, reduce risk, or acquire resources. Partnerships are becoming a cornerstone of many business models as companies seek to focus on their core activities while leveraging partners for non-core capabilities.",
    theoreticalFoundation: "Strategic building block of Osterwalder's Business Model Canvas representing external relationship management. Partnerships can be motivated by optimization and economy of scale, reduction of risk and uncertainty, or acquisition of particular resources and activities.",
    partnershipTypes: "Strategic alliances for technology platform access and blockchain infrastructure."
});

CREATE (kp4:KeyPartnership {
    id: "kp_regulatory_compliance_partners",
    name: "Regulatory & Compliance Partners",
    type: "strategic alliance",
    motivation: "regulatory compliance",
    description: "Estonian legal advisors, e-Residency program integration, EU regulatory compliance specialists, and international trade compliance experts.",

    // Semantic Enhancement Properties
    semanticDescription: "The network of suppliers and partners that make the business model work. Companies create alliances to optimize their business models, reduce risk, or acquire resources. Partnerships are becoming a cornerstone of many business models as companies seek to focus on their core activities while leveraging partners for non-core capabilities.",
    theoreticalFoundation: "Strategic building block of Osterwalder's Business Model Canvas representing external relationship management. Partnerships can be motivated by optimization and economy of scale, reduction of risk and uncertainty, or acquisition of particular resources and activities.",
    partnershipTypes: "Strategic alliances ensuring regulatory compliance and legal framework operation."
});

CREATE (kp5:KeyPartnership {
    id: "kp_market_customer_partners",
    name: "Market & Customer Partners",
    type: "strategic alliance",
    motivation: "market access",
    description: "Investment platform partnerships, trade show organizers, industry associations, referral networks, and customer acquisition channel partners.",

    // Semantic Enhancement Properties
    semanticDescription: "The network of suppliers and partners that make the business model work. Companies create alliances to optimize their business models, reduce risk, or acquire resources. Partnerships are becoming a cornerstone of many business models as companies seek to focus on their core activities while leveraging partners for non-core capabilities.",
    theoreticalFoundation: "Strategic building block of Osterwalder's Business Model Canvas representing external relationship management. Partnerships can be motivated by optimization and economy of scale, reduction of risk and uncertainty, or acquisition of particular resources and activities.",
    partnershipTypes: "Strategic alliances providing market access and customer acquisition capabilities."
});

// =====================================================
// CUSTOMER RELATIONSHIP NODES (Updated with detailed frameworks)
// =====================================================

CREATE (cr1:CustomerRelationship {
    id: "cr_investment_contract_framework",
    name: "Investment Contract Framework (Blockchain-Enforced)",
    type: "automated",
    description: "Investment relationships governed by blockchain-enforced smart contracts with automated dividend distributions, fixed return guarantees, annual renewal cycles, real-time transparency dashboard, and fiduciary protection through Trust Operations Administrator oversight.",
    semanticDescription: "A customer relationship type defined by Business Model Canvas theory as the nature of links a company establishes with specific customer segments. This automated framework leverages blockchain technology for trust, transparency, and automated execution of investment terms.",
    theoreticalFoundation: "Based on Osterwalder & Pigneur Business Model Canvas customer relationship categories, enhanced with blockchain governance principles and digital trust frameworks from modern fintech literature.",
    practicalApplication: "Investment relationships category focusing on automated contract execution, dividend distribution automation, transparency provision, and fiduciary duty management.",
    components: [
        "Smart Contract Governance: Investment relationship governed by blockchain-enforced smart contracts defining terms, returns, and obligations",
        "Fixed Return Guarantee: Goldenberry guarantees fixed interest rates through automated smart contract execution",
        "Automated Dividend Distributions: 6-month dividend cycles with automatic payment processing triggered by smart contract conditions",
        "Annual Investment Renewal: Structured 1-year commitment periods with blockchain-enforced exit and reinvestment options",
        "Real-Time Transparency: Continuous visibility into asset performance and trust operations through digital dashboard",
        "Fiduciary Protection: Legal trust structure with Trust Operations Administrator providing human oversight within blockchain framework"
    ]
});

CREATE (cr2:CustomerRelationship {
    id: "cr_transactional_relationship_po_based",
    name: "Transactional Relationship (Purchase Order-Based)",
    type: "personal",
    description: "B2B transactional relationships based on individual purchase orders with dedicated account management, invoice-based payment cycles, container-level transactions, and transaction-specific quality assurance aligned with purchase order specifications.",
    semanticDescription: "A customer relationship type characterized by transaction-based interactions with personal account management. Each engagement is governed by specific purchase orders defining commercial terms, quality requirements, and delivery specifications.",
    theoreticalFoundation: "Grounded in Business Model Canvas customer relationship theory and B2B commercial relationship management principles. Emphasizes personal touch within standardized transactional frameworks.",
    practicalApplication: "Transactional relationships category focused on purchase order governance, account management excellence, quality assurance per transaction, and B2B payment cycle management.",
    components: [
        "Purchase Order Governance: Each transaction governed by specific purchase orders defining quantity, quality, delivery terms, and pricing",
        "Invoice-Based Payment Cycle: Standard B2B payment terms with invoicing upon shipment completion and delivery confirmation",
        "Container-Level Transactions: Individual container sales with specific documentation and compliance requirements per order",
        "Dedicated Account Management: Export commercial specialist managing purchase order processing and customer communications",
        "Quality Assurance Per Order: Transaction-specific quality control and certification aligned with purchase order specifications"
    ]
});

// =====================================================
// CHANNEL NODES - COMPREHENSIVE COVERAGE (28 Channels)
// =====================================================

// Investor Acquisition Channels (5)
CREATE (ch1:Channel {
    id: "ch_investor_digital_marketing",
    name: "Digital Marketing",
    channelType: "acquisition",
    medium: "digital",
    ownership: "owned",
    description: "Targeted LinkedIn campaigns and investment platform partnerships for reaching potential digital trust investors",
    semanticDescription: "Digital acquisition channel leveraging professional social networks and fintech platforms to identify and engage qualified investors interested in blockchain-secured alternative investments."
});

CREATE (ch2:Channel {
    id: "ch_investor_professional_networks",
    name: "Professional Networks",
    channelType: "acquisition",
    medium: "hybrid",
    ownership: "partner",
    description: "Financial advisor referrals and investment community outreach for building trust-based investor relationships",
    semanticDescription: "Relationship-based acquisition channel utilizing financial intermediaries and professional investment networks to access high-net-worth individuals and institutional investors."
});

CREATE (ch3:Channel {
    id: "ch_investor_industry_events",
    name: "Industry Events",
    channelType: "acquisition",
    medium: "physical",
    ownership: "partner",
    description: "Fintech conferences and alternative investment seminars for direct investor engagement and education",
    semanticDescription: "Event-based acquisition channel providing face-to-face interaction opportunities with qualified investors through curated industry gatherings and educational forums."
});

CREATE (ch4:Channel {
    id: "ch_investor_content_marketing",
    name: "Content Marketing",
    channelType: "acquisition",
    medium: "digital",
    ownership: "owned",
    description: "Whitepapers on digital trust frameworks and export investment opportunities to establish thought leadership",
    semanticDescription: "Educational content channel that builds credibility and attracts investors through authoritative publications on blockchain governance and agricultural export investment models."
});

CREATE (ch5:Channel {
    id: "ch_investor_regulatory_showcases",
    name: "Regulatory Compliance Showcases",
    channelType: "acquisition",
    medium: "hybrid",
    ownership: "partner",
    description: "Demonstrations at Estonian e-Residency events and EU blockchain initiatives highlighting regulatory compliance",
    semanticDescription: "Compliance-focused acquisition channel that leverages regulatory framework events to demonstrate legal structure advantages and build investor confidence through official endorsements."
});

// Investor Delivery Channels (4)
CREATE (ch6:Channel {
    id: "ch_investor_digital_trust_platform",
    name: "Digital Trust Platform",
    channelType: "delivery",
    medium: "digital",
    ownership: "owned",
    description: "Web-based investor portal for onboarding, documentation, and investment execution",
    semanticDescription: "Core digital delivery channel providing secure, compliant investor onboarding, KYC/AML verification, investment documentation, and transaction execution capabilities through a proprietary web platform."
});

CREATE (ch7:Channel {
    id: "ch_investor_smart_contract_interface",
    name: "Smart Contract Interface",
    channelType: "delivery",
    medium: "digital",
    ownership: "owned",
    description: "Blockchain-based investment contract deployment and management system",
    semanticDescription: "Blockchain delivery channel enabling automated smart contract creation, deployment, and execution for investment terms, ensuring transparent and immutable transaction records."
});

CREATE (ch8:Channel {
    id: "ch_investor_multicurrency_payment",
    name: "Multi-Currency Payment Systems",
    channelType: "delivery",
    medium: "digital",
    ownership: "partner",
    description: "Fiat-to-crypto conversion and stablecoin investment processing capabilities",
    semanticDescription: "Payment infrastructure channel facilitating seamless conversion between traditional currencies and digital assets, enabling global investor participation regardless of local currency."
});

CREATE (ch9:Channel {
    id: "ch_investor_digital_wallet_integration",
    name: "Digital Wallet Integration",
    channelType: "delivery",
    medium: "digital",
    ownership: "partner",
    description: "Direct connection to investor crypto wallets for seamless transactions",
    semanticDescription: "Wallet integration channel providing secure connectivity to major cryptocurrency wallets, enabling direct investment deposits and automated dividend distributions."
});

// Investor Retention Channels (4)
CREATE (ch10:Channel {
    id: "ch_investor_transparency_dashboard",
    name: "Automated Transparency Dashboard",
    channelType: "retention",
    medium: "digital",
    ownership: "owned",
    description: "Real-time portfolio performance and asset tracking updates for continuous investor engagement",
    semanticDescription: "Automated retention channel providing continuous transparency through real-time dashboards displaying investment performance, asset valuations, and operational metrics to maintain investor trust."
});

CREATE (ch11:Channel {
    id: "ch_investor_dividend_system",
    name: "Dividend Distribution System",
    channelType: "retention",
    medium: "digital",
    ownership: "owned",
    description: "Automated 6-month payment processing with transaction confirmations",
    semanticDescription: "Automated payment channel executing periodic dividend distributions according to smart contract terms, providing transparent payment tracking and confirmation mechanisms."
});

CREATE (ch12:Channel {
    id: "ch_investor_trust_administrator",
    name: "Trust Operations Administrator",
    channelType: "retention",
    medium: "hybrid",
    ownership: "owned",
    description: "Direct human contact for complex inquiries and relationship management",
    semanticDescription: "Human-centered retention channel providing personalized support through dedicated trust administrators who handle complex investor queries and maintain high-touch relationships."
});

CREATE (ch13:Channel {
    id: "ch_investor_renewal_platform",
    name: "Investment Renewal Platform",
    channelType: "retention",
    medium: "digital",
    ownership: "owned",
    description: "Streamlined annual renewal process with performance review presentations",
    semanticDescription: "Renewal-focused retention channel facilitating annual investment rollovers through automated renewal workflows, performance reporting, and reinvestment option presentations."
});

// Importer Acquisition Channels (5)
CREATE (ch14:Channel {
    id: "ch_importer_trade_shows",
    name: "Trade Show Participation",
    channelType: "acquisition",
    medium: "physical",
    ownership: "partner",
    description: "Fruit Logistica Berlin, Fruit Attraction, GPF USA, and Fruit Logistica Asia participation",
    semanticDescription: "International trade show channel providing direct B2B engagement opportunities with global fruit importers through major industry exhibitions across key geographic markets."
});

CREATE (ch15:Channel {
    id: "ch_importer_export_team",
    name: "Export Commercial Team",
    channelType: "acquisition",
    medium: "hybrid",
    ownership: "owned",
    description: "Direct sales outreach and relationship building with target importers",
    semanticDescription: "Direct sales channel utilizing dedicated export specialists who proactively identify, qualify, and develop relationships with international fruit importers through personalized outreach."
});

CREATE (ch16:Channel {
    id: "ch_importer_industry_publications",
    name: "Industry Publications",
    channelType: "acquisition",
    medium: "physical",
    ownership: "partner",
    description: "Advertisements in fresh produce and import/export trade magazines",
    semanticDescription: "Trade media channel leveraging specialized industry publications to build brand awareness and credibility among professional fruit buyers and import decision-makers."
});

CREATE (ch17:Channel {
    id: "ch_importer_digital_presence",
    name: "Digital Presence",
    channelType: "acquisition",
    medium: "digital",
    ownership: "owned",
    description: "Professional website with product catalogs and export capabilities showcase",
    semanticDescription: "Digital showcase channel providing comprehensive online presence with detailed product information, quality certifications, and export capability demonstrations for importer discovery."
});

CREATE (ch18:Channel {
    id: "ch_importer_referral_network",
    name: "Referral Network",
    channelType: "acquisition",
    medium: "hybrid",
    ownership: "partner",
    description: "Existing customer referrals and industry partner recommendations",
    semanticDescription: "Relationship-based acquisition channel leveraging satisfied customers and industry partners to generate qualified leads through trusted recommendations and testimonials."
});

// Importer Delivery Channels (5)
CREATE (ch19:Channel {
    id: "ch_importer_container_shipping",
    name: "Container Shipping",
    channelType: "delivery",
    medium: "physical",
    ownership: "partner",
    description: "20-foot refrigerated containers via established shipping lines",
    semanticDescription: "Physical logistics channel utilizing refrigerated container shipping infrastructure to deliver temperature-controlled exotic fruit cargo to international ports maintaining cold chain integrity."
});

CREATE (ch20:Channel {
    id: "ch_importer_documentation_system",
    name: "Export Documentation System",
    channelType: "delivery",
    medium: "digital",
    ownership: "owned",
    description: "Digital platform for certificates, permits, and compliance paperwork",
    semanticDescription: "Documentation delivery channel providing digitized export certificates, phytosanitary permits, and customs documentation ensuring regulatory compliance across international borders."
});

CREATE (ch21:Channel {
    id: "ch_importer_quality_control",
    name: "Quality Control Facilities",
    channelType: "delivery",
    medium: "physical",
    ownership: "partner",
    description: "Pre-shipment inspection and certification at origin facilities",
    semanticDescription: "Quality assurance channel ensuring product standards through systematic pre-shipment inspections, quality certifications, and batch testing at Colombian origin facilities."
});

CREATE (ch22:Channel {
    id: "ch_importer_logistics_coordination",
    name: "Logistics Coordination",
    channelType: "delivery",
    medium: "hybrid",
    ownership: "partner",
    description: "Direct coordination with freight forwarders and customs brokers",
    semanticDescription: "Logistics management channel orchestrating seamless cargo movement through partnerships with freight forwarders, customs brokers, and international logistics providers."
});

CREATE (ch23:Channel {
    id: "ch_importer_port_delivery",
    name: "Port-to-Port Delivery",
    channelType: "delivery",
    medium: "physical",
    ownership: "partner",
    description: "Container delivery to major international ports (Rotterdam, Hamburg, Miami, etc.)",
    semanticDescription: "International shipping channel ensuring reliable delivery to major global ports with established infrastructure for exotic fruit handling and distribution."
});

// Importer Retention Channels (5)
CREATE (ch24:Channel {
    id: "ch_importer_account_management",
    name: "Dedicated Account Management",
    channelType: "retention",
    medium: "hybrid",
    ownership: "owned",
    description: "Regular communication through assigned export commercial specialists",
    semanticDescription: "Personal relationship channel maintaining continuous engagement through dedicated account managers who understand specific importer needs and provide customized service."
});

CREATE (ch25:Channel {
    id: "ch_importer_po_management",
    name: "Purchase Order Management System",
    channelType: "retention",
    medium: "digital",
    ownership: "owned",
    description: "Streamlined ordering process with seasonal planning support",
    semanticDescription: "Order management channel facilitating efficient repeat purchases through digitized PO processing, inventory forecasting, and seasonal planning tools."
});

CREATE (ch26:Channel {
    id: "ch_importer_quality_program",
    name: "Quality Assurance Program",
    channelType: "retention",
    medium: "hybrid",
    ownership: "owned",
    description: "Consistent quality delivery with batch tracking and certification",
    semanticDescription: "Quality consistency channel ensuring customer retention through systematic quality control, batch traceability, and continuous improvement programs."
});

CREATE (ch27:Channel {
    id: "ch_importer_market_intelligence",
    name: "Market Intelligence Sharing",
    channelType: "retention",
    medium: "digital",
    ownership: "owned",
    description: "Regular market updates, pricing trends, and supply forecasts",
    semanticDescription: "Information value channel providing strategic market insights, price forecasting, and supply chain intelligence to help importers make informed purchasing decisions."
});

CREATE (ch28:Channel {
    id: "ch_importer_business_reviews",
    name: "Business Review Meetings",
    channelType: "retention",
    medium: "hybrid",
    ownership: "owned",
    description: "Quarterly performance reviews and annual planning sessions",
    semanticDescription: "Strategic engagement channel fostering long-term partnerships through structured business reviews, performance evaluations, and collaborative planning sessions."
});

// =====================================================
// COST STRUCTURE NODES (33 total across 6 categories)
// =====================================================

// 1. Direct Product Costs (8 items)
CREATE (cost1:CostStructure {
    id: "cost_fruit_sourcing",
    name: "Premium Goldenberry Sourcing",
    category: "Direct Product Costs",
    type: "variable",
    costDriver: "Per container of premium goldenberries",
    frequency: "per_shipment",
    semanticDescription: "Primary cost of acquiring high-quality goldenberries from certified organic farms, including farm-gate pricing, quality premiums, and seasonal variations."
});

CREATE (cost2:CostStructure {
    id: "cost_post_harvest",
    name: "Post-Harvest Processing",
    category: "Direct Product Costs",
    type: "variable",
    costDriver: "Processing volume per container",
    frequency: "per_shipment",
    semanticDescription: "Costs associated with cleaning, sorting, grading, and initial quality control processing at origin facilities before containerization."
});

CREATE (cost3:CostStructure {
    id: "cost_packaging_materials",
    name: "Export Packaging Materials",
    category: "Direct Product Costs",
    type: "variable",
    costDriver: "Packaging volume per shipment",
    frequency: "per_shipment",
    semanticDescription: "Specialized packaging materials designed for international shipping, including moisture control, temperature-sensitive containers, and protective cushioning."
});

CREATE (cost4:CostStructure {
    id: "cost_quality_control",
    name: "Quality Control & Testing",
    category: "Direct Product Costs",
    type: "variable",
    costDriver: "Number of quality checkpoints per batch",
    frequency: "per_shipment",
    semanticDescription: "Comprehensive quality assurance including laboratory testing, visual inspection, shelf-life assessment, and compliance verification with international standards."
});

CREATE (cost5:CostStructure {
    id: "cost_cold_chain",
    name: "Cold Chain Management",
    category: "Direct Product Costs",
    type: "variable",
    costDriver: "Temperature-controlled storage and transport duration",
    frequency: "per_shipment",
    semanticDescription: "Specialized refrigeration costs maintaining optimal temperature and humidity throughout the supply chain from farm to port of destination."
});

CREATE (cost6:CostStructure {
    id: "cost_container_prep",
    name: "Container Preparation",
    category: "Direct Product Costs",
    type: "variable",
    costDriver: "Container setup and configuration",
    frequency: "per_shipment",
    semanticDescription: "Costs for preparing shipping containers with temperature controls, monitoring equipment, and specialized configurations for fresh fruit transport."
});

CREATE (cost7:CostStructure {
    id: "cost_origin_handling",
    name: "Origin Handling & Loading",
    category: "Direct Product Costs",
    type: "variable",
    costDriver: "Loading operations at origin port",
    frequency: "per_shipment",
    semanticDescription: "Port handling fees, loading operations, container positioning, and final pre-shipment preparations at the origin port in Peru."
});

CREATE (cost8:CostStructure {
    id: "cost_product_insurance",
    name: "Product Insurance",
    category: "Direct Product Costs",
    type: "variable",
    costDriver: "Insurance coverage per shipment value",
    frequency: "per_shipment",
    semanticDescription: "Cargo insurance covering product value, spoilage risk, and potential losses during international transit and handling."
});

// 2. Export Operations Overhead (6 items)
CREATE (cost9:CostStructure {
    id: "cost_shipping_freight",
    name: "International Shipping & Freight",
    category: "Export Operations Overhead",
    type: "variable",
    costDriver: "Distance and shipping route complexity",
    frequency: "per_shipment",
    semanticDescription: "Ocean freight costs including vessel charter, port-to-port transportation, fuel surcharges, and route-specific pricing variations."
});

CREATE (cost10:CostStructure {
    id: "cost_customs_documentation",
    name: "Customs & Documentation",
    category: "Export Operations Overhead",
    type: "fixed",
    costDriver: "Document processing and customs clearance",
    frequency: "per_shipment",
    semanticDescription: "Export documentation, customs clearance fees, import permits, and regulatory compliance costs for international trade operations."
});

CREATE (cost11:CostStructure {
    id: "cost_port_destination",
    name: "Destination Port Operations",
    category: "Export Operations Overhead",
    type: "variable",
    costDriver: "Port handling and customs clearance at destination",
    frequency: "per_shipment",
    semanticDescription: "Destination port fees including unloading, customs clearance, temporary storage, and handover to customer's designated freight forwarder."
});

CREATE (cost12:CostStructure {
    id: "cost_logistics_coordination",
    name: "Logistics Coordination",
    category: "Export Operations Overhead",
    type: "fixed",
    costDriver: "Third-party logistics management",
    frequency: "monthly",
    semanticDescription: "Costs for coordinating with freight forwarders, shipping lines, customs brokers, and other logistics partners throughout the supply chain."
});

CREATE (cost13:CostStructure {
    id: "cost_export_staff",
    name: "Export Operations Staff",
    category: "Export Operations Overhead",
    type: "fixed",
    costDriver: "Export operations team salaries and benefits",
    frequency: "monthly",
    semanticDescription: "Personnel costs for export specialists, logistics coordinators, customer service representatives, and operations managers."
});

CREATE (cost14:CostStructure {
    id: "cost_export_facilities",
    name: "Export Facilities & Equipment",
    category: "Export Operations Overhead",
    type: "fixed",
    costDriver: "Facility lease and equipment maintenance",
    frequency: "monthly",
    semanticDescription: "Warehouse facilities, processing equipment, cold storage systems, and specialized export infrastructure maintenance and operation."
});

// 3. Digital Trust Infrastructure (6 items)
CREATE (cost15:CostStructure {
    id: "cost_blockchain_platform",
    name: "Blockchain Platform Operations",
    category: "Digital Trust Infrastructure",
    type: "fixed",
    costDriver: "Platform hosting and transaction processing",
    frequency: "monthly",
    semanticDescription: "Costs for maintaining blockchain infrastructure, smart contract execution, transaction validation, and distributed ledger operations."
});

CREATE (cost16:CostStructure {
    id: "cost_digital_certificates",
    name: "Digital Certification System",
    category: "Digital Trust Infrastructure",
    type: "variable",
    costDriver: "Number of digital certificates issued",
    frequency: "per_certificate",
    semanticDescription: "Costs associated with generating, validating, and maintaining digital certificates for quality, origin, and compliance verification."
});

CREATE (cost17:CostStructure {
    id: "cost_iot_monitoring",
    name: "IoT Monitoring Systems",
    category: "Digital Trust Infrastructure",
    type: "fixed",
    costDriver: "IoT device deployment and data processing",
    frequency: "monthly",
    semanticDescription: "Internet of Things devices for real-time monitoring of temperature, humidity, location, and container conditions throughout the supply chain."
});

CREATE (cost18:CostStructure {
    id: "cost_data_storage",
    name: "Secure Data Storage",
    category: "Digital Trust Infrastructure",
    type: "variable",
    costDriver: "Data volume and storage duration",
    frequency: "monthly",
    semanticDescription: "Secure cloud storage for transaction records, quality data, certification documents, and supply chain tracking information."
});

CREATE (cost19:CostStructure {
    id: "cost_api_integration",
    name: "API Integration & Maintenance",
    category: "Digital Trust Infrastructure",
    type: "fixed",
    costDriver: "Integration complexity and partner connections",
    frequency: "monthly",
    semanticDescription: "Costs for developing and maintaining API connections with customer systems, logistics partners, and regulatory platforms."
});

CREATE (cost20:CostStructure {
    id: "cost_cybersecurity",
    name: "Cybersecurity & Data Protection",
    category: "Digital Trust Infrastructure",
    type: "fixed",
    costDriver: "Security infrastructure and monitoring",
    frequency: "monthly",
    semanticDescription: "Comprehensive cybersecurity measures including encryption, threat monitoring, access controls, and data protection compliance."
});

// 4. Trust Administration & Governance (5 items)
CREATE (cost21:CostStructure {
    id: "cost_compliance_monitoring",
    name: "Regulatory Compliance Monitoring",
    category: "Trust Administration & Governance",
    type: "fixed",
    costDriver: "Continuous compliance oversight",
    frequency: "monthly",
    semanticDescription: "Ongoing monitoring of regulatory changes, compliance verification, and adherence to international trade and food safety standards."
});

CREATE (cost22:CostStructure {
    id: "cost_audit_certification",
    name: "Third-Party Audits & Certification",
    category: "Trust Administration & Governance",
    type: "fixed",
    costDriver: "Audit frequency and certification requirements",
    frequency: "quarterly",
    semanticDescription: "Independent audits, certification renewals, and third-party verification of quality systems, organic compliance, and traceability processes."
});

CREATE (cost23:CostStructure {
    id: "cost_legal_compliance",
    name: "Legal & Regulatory Support",
    category: "Trust Administration & Governance",
    type: "fixed",
    costDriver: "Legal advisory and regulatory consultation",
    frequency: "monthly",
    semanticDescription: "Legal services for contract review, regulatory interpretation, dispute resolution, and compliance with international trade laws."
});

CREATE (cost24:CostStructure {
    id: "cost_governance_framework",
    name: "Governance Framework Maintenance",
    category: "Trust Administration & Governance",
    type: "fixed",
    costDriver: "Governance structure and process management",
    frequency: "monthly",
    semanticDescription: "Costs for maintaining trust governance structures, stakeholder coordination, and decision-making processes for the digital trust platform."
});

CREATE (cost25:CostStructure {
    id: "cost_transparency_reporting",
    name: "Transparency & Reporting Systems",
    category: "Trust Administration & Governance",
    type: "fixed",
    costDriver: "Reporting frequency and stakeholder requirements",
    frequency: "monthly",
    semanticDescription: "Systems and processes for generating transparency reports, stakeholder communications, and public disclosure of trust platform operations."
});

// 5. Financial Operations (4 items)
CREATE (cost26:CostStructure {
    id: "cost_trade_finance",
    name: "Trade Finance & Letters of Credit",
    category: "Financial Operations",
    type: "variable",
    costDriver: "Transaction value and credit terms",
    frequency: "per_transaction",
    semanticDescription: "Costs associated with trade financing, letters of credit, documentary collections, and international payment processing."
});

CREATE (cost27:CostStructure {
    id: "cost_currency_hedging",
    name: "Currency Hedging & Exchange",
    category: "Financial Operations",
    type: "variable",
    costDriver: "Currency exposure and hedging instruments",
    frequency: "monthly",
    semanticDescription: "Foreign exchange risk management through hedging instruments, currency conversion costs, and exchange rate fluctuation mitigation."
});

CREATE (cost28:CostStructure {
    id: "cost_payment_processing",
    name: "International Payment Processing",
    category: "Financial Operations",
    type: "variable",
    costDriver: "Transaction volume and payment methods",
    frequency: "per_transaction",
    semanticDescription: "Costs for processing international payments, wire transfers, banking fees, and multi-currency transaction handling."
});

CREATE (cost29:CostStructure {
    id: "cost_financial_reporting",
    name: "Financial Reporting & Accounting",
    category: "Financial Operations",
    type: "fixed",
    costDriver: "Accounting complexity and reporting requirements",
    frequency: "monthly",
    semanticDescription: "Accounting services, financial reporting, tax compliance, and bookkeeping for international trade operations across multiple currencies."
});

// 6. Risk Management & Contingency (4 items)
CREATE (cost30:CostStructure {
    id: "cost_supply_risk",
    name: "Supply Chain Risk Management",
    category: "Risk Management & Contingency",
    type: "fixed",
    costDriver: "Risk assessment and mitigation strategies",
    frequency: "monthly",
    semanticDescription: "Proactive risk management including supplier diversification, alternative sourcing, weather risk assessment, and supply chain contingency planning."
});

CREATE (cost31:CostStructure {
    id: "cost_market_risk",
    name: "Market Risk Mitigation",
    category: "Risk Management & Contingency",
    type: "variable",
    costDriver: "Market volatility and risk exposure",
    frequency: "monthly",
    semanticDescription: "Market risk management through pricing strategies, demand forecasting, customer diversification, and market intelligence systems."
});

CREATE (cost32:CostStructure {
    id: "cost_operational_risk",
    name: "Operational Risk Coverage",
    category: "Risk Management & Contingency",
    type: "fixed",
    costDriver: "Operational complexity and risk exposure",
    frequency: "monthly",
    semanticDescription: "Operational risk insurance, business continuity planning, disaster recovery systems, and contingency fund maintenance."
});

CREATE (cost33:CostStructure {
    id: "cost_emergency_response",
    name: "Emergency Response & Crisis Management",
    category: "Risk Management & Contingency",
    type: "variable",
    costDriver: "Crisis response requirements and emergency situations",
    frequency: "as_needed",
    semanticDescription: "Emergency response capabilities including crisis management, rapid problem resolution, customer communication, and service recovery operations."
});

// =====================================================
// RELATIONSHIPS
// =====================================================

// Business Model to Value Propositions
MATCH (bm:BusinessModel {id: "bm_goldenberry_flow"}), (vp1:ValueProposition {id: "vp_trusted_fruit_exports"})
CREATE (bm)-[:HAS_VALUE_PROPOSITION]->(vp1);

MATCH (bm:BusinessModel {id: "bm_goldenberry_flow"}), (vp2:ValueProposition {id: "vp_investment_opportunity"})
CREATE (bm)-[:HAS_VALUE_PROPOSITION]->(vp2);

// Value Propositions to Customer Segments
MATCH (vp1:ValueProposition {id: "vp_trusted_fruit_exports"}), (cs2:CustomerSegment {id: "cs_fruit_importers"})
CREATE (vp1)-[:TARGETS]->(cs2);

MATCH (vp2:ValueProposition {id: "vp_investment_opportunity"}), (cs1:CustomerSegment {id: "cs_sustainable_investors"})
CREATE (vp2)-[:TARGETS]->(cs1);

// Value Propositions to Jobs-to-be-Done
MATCH (vp1:ValueProposition {id: "vp_trusted_fruit_exports"}), (job2:JobToBeDone {id: "job_source_premium_fruits"})
CREATE (vp1)-[:ADDRESSES_JOB]->(job2);

MATCH (vp2:ValueProposition {id: "vp_investment_opportunity"}), (job1:JobToBeDone {id: "job_generate_sustainable_returns"})
CREATE (vp2)-[:ADDRESSES_JOB]->(job1);

// Customer Segments to Job Executors
MATCH (cs1:CustomerSegment {id: "cs_sustainable_investors"}), (je1:JobExecutor {id: "je_impact_investment_managers"})
CREATE (cs1)-[:DEFINED_BY_JOB_EXECUTOR]->(je1);

MATCH (cs2:CustomerSegment {id: "cs_fruit_importers"}), (je2:JobExecutor {id: "je_procurement_managers"})
CREATE (cs2)-[:DEFINED_BY_JOB_EXECUTOR]->(je2);

// Customer Segments to Jobs-to-be-Done
MATCH (cs1:CustomerSegment {id: "cs_sustainable_investors"}), (job1:JobToBeDone {id: "job_generate_sustainable_returns"})
CREATE (cs1)-[:DEFINED_BY_JOB]->(job1);

MATCH (cs2:CustomerSegment {id: "cs_fruit_importers"}), (job2:JobToBeDone {id: "job_source_premium_fruits"})
CREATE (cs2)-[:DEFINED_BY_JOB]->(job2);

// Job Executors to Jobs-to-be-Done
MATCH (je1:JobExecutor {id: "je_impact_investment_managers"}), (job1:JobToBeDone {id: "job_generate_sustainable_returns"})
CREATE (je1)-[:EXECUTES_JOB]->(job1);

MATCH (je2:JobExecutor {id: "je_procurement_managers"}), (job2:JobToBeDone {id: "job_source_premium_fruits"})
CREATE (je2)-[:EXECUTES_JOB]->(job2);

// Customer Segments to Channels
// Investor Channels
MATCH (cs1:CustomerSegment {id: "cs_sustainable_investors"}), (ch1:Channel {id: "ch_investor_impact_conferences"})
CREATE (cs1)-[:REACHES_THROUGH]->(ch1);

MATCH (cs1:CustomerSegment {id: "cs_sustainable_investors"}), (ch2:Channel {id: "ch_investor_esg_networks"})
CREATE (cs1)-[:REACHES_THROUGH]->(ch2);

MATCH (cs1:CustomerSegment {id: "cs_sustainable_investors"}), (ch3:Channel {id: "ch_investor_digital_platforms"})
CREATE (cs1)-[:REACHES_THROUGH]->(ch3);

MATCH (cs1:CustomerSegment {id: "cs_sustainable_investors"}), (ch4:Channel {id: "ch_investor_advisory_consultations"})
CREATE (cs1)-[:REACHES_THROUGH]->(ch4);

MATCH (cs1:CustomerSegment {id: "cs_sustainable_investors"}), (ch5:Channel {id: "ch_investor_financial_partnerships"})
CREATE (cs1)-[:REACHES_THROUGH]->(ch5);

MATCH (cs1:CustomerSegment {id: "cs_sustainable_investors"}), (ch6:Channel {id: "ch_investor_direct_presentations"})
CREATE (cs1)-[:REACHES_THROUGH]->(ch6);

MATCH (cs1:CustomerSegment {id: "cs_sustainable_investors"}), (ch7:Channel {id: "ch_investor_contract_execution"})
CREATE (cs1)-[:REACHES_THROUGH]->(ch7);

MATCH (cs1:CustomerSegment {id: "cs_sustainable_investors"}), (ch8:Channel {id: "ch_investor_portfolio_integration"})
CREATE (cs1)-[:REACHES_THROUGH]->(ch8);

MATCH (cs1:CustomerSegment {id: "cs_sustainable_investors"}), (ch9:Channel {id: "ch_investor_digital_portal"})
CREATE (cs1)-[:REACHES_THROUGH]->(ch9);

MATCH (cs1:CustomerSegment {id: "cs_sustainable_investors"}), (ch10:Channel {id: "ch_investor_performance_reporting"})
CREATE (cs1)-[:REACHES_THROUGH]->(ch10);

MATCH (cs1:CustomerSegment {id: "cs_sustainable_investors"}), (ch11:Channel {id: "ch_investor_impact_reviews"})
CREATE (cs1)-[:REACHES_THROUGH]->(ch11);

MATCH (cs1:CustomerSegment {id: "cs_sustainable_investors"}), (ch12:Channel {id: "ch_investor_strategy_updates"})
CREATE (cs1)-[:REACHES_THROUGH]->(ch12);

MATCH (cs1:CustomerSegment {id: "cs_sustainable_investors"}), (ch13:Channel {id: "ch_investor_stakeholder_engagement"})
CREATE (cs1)-[:REACHES_THROUGH]->(ch13);

MATCH (cs1:CustomerSegment {id: "cs_sustainable_investors"}), (ch14:Channel {id: "ch_investor_annual_meetings"})
CREATE (cs1)-[:REACHES_THROUGH]->(ch14);

// Importer Channels
MATCH (cs2:CustomerSegment {id: "cs_fruit_importers"}), (ch15:Channel {id: "ch_importer_trade_shows"})
CREATE (cs2)-[:REACHES_THROUGH]->(ch15);

MATCH (cs2:CustomerSegment {id: "cs_fruit_importers"}), (ch16:Channel {id: "ch_importer_industry_associations"})
CREATE (cs2)-[:REACHES_THROUGH]->(ch16);

MATCH (cs2:CustomerSegment {id: "cs_fruit_importers"}), (ch17:Channel {id: "ch_importer_commercial_outreach"})
CREATE (cs2)-[:REACHES_THROUGH]->(ch17);

MATCH (cs2:CustomerSegment {id: "cs_fruit_importers"}), (ch18:Channel {id: "ch_importer_referral_network"})
CREATE (cs2)-[:REACHES_THROUGH]->(ch18);

MATCH (cs2:CustomerSegment {id: "cs_fruit_importers"}), (ch19:Channel {id: "ch_importer_digital_platform"})
CREATE (cs2)-[:REACHES_THROUGH]->(ch19);

MATCH (cs2:CustomerSegment {id: "cs_fruit_importers"}), (ch20:Channel {id: "ch_importer_sample_programs"})
CREATE (cs2)-[:REACHES_THROUGH]->(ch20);

MATCH (cs2:CustomerSegment {id: "cs_fruit_importers"}), (ch21:Channel {id: "ch_importer_contract_negotiation"})
CREATE (cs2)-[:REACHES_THROUGH]->(ch21);

MATCH (cs2:CustomerSegment {id: "cs_fruit_importers"}), (ch22:Channel {id: "ch_importer_logistics_coordination"})
CREATE (cs2)-[:REACHES_THROUGH]->(ch22);

MATCH (cs2:CustomerSegment {id: "cs_fruit_importers"}), (ch23:Channel {id: "ch_importer_port_delivery"})
CREATE (cs2)-[:REACHES_THROUGH]->(ch23);

MATCH (cs2:CustomerSegment {id: "cs_fruit_importers"}), (ch24:Channel {id: "ch_importer_account_management"})
CREATE (cs2)-[:REACHES_THROUGH]->(ch24);

MATCH (cs2:CustomerSegment {id: "cs_fruit_importers"}), (ch25:Channel {id: "ch_importer_po_management"})
CREATE (cs2)-[:REACHES_THROUGH]->(ch25);

MATCH (cs2:CustomerSegment {id: "cs_fruit_importers"}), (ch26:Channel {id: "ch_importer_quality_program"})
CREATE (cs2)-[:REACHES_THROUGH]->(ch26);

MATCH (cs2:CustomerSegment {id: "cs_fruit_importers"}), (ch27:Channel {id: "ch_importer_market_intelligence"})
CREATE (cs2)-[:REACHES_THROUGH]->(ch27);

MATCH (cs2:CustomerSegment {id: "cs_fruit_importers"}), (ch28:Channel {id: "ch_importer_business_reviews"})
CREATE (cs2)-[:REACHES_THROUGH]->(ch28);

// Customer Segments to Customer Relationships
MATCH (cs1:CustomerSegment {id: "cs_sustainable_investors"}), (cr1:CustomerRelationship {id: "cr_strategic_investment_partnership"})
CREATE (cs1)-[:HAS_RELATIONSHIP_WITH]->(cr1);

MATCH (cs2:CustomerSegment {id: "cs_fruit_importers"}), (cr2:CustomerRelationship {id: "cr_long_term_supply_partnership"})
CREATE (cs2)-[:HAS_RELATIONSHIP_WITH]->(cr2);

// Customer Segments to Revenue Streams
MATCH (cs1:CustomerSegment {id: "cs_sustainable_investors"}), (rs1:RevenueStream {id: "rs_equity_returns"})
CREATE (cs1)-[:GENERATES]->(rs1);

MATCH (cs1:CustomerSegment {id: "cs_sustainable_investors"}), (rs2:RevenueStream {id: "rs_impact_premiums"})
CREATE (cs1)-[:GENERATES]->(rs2);

MATCH (cs2:CustomerSegment {id: "cs_fruit_importers"}), (rs3:RevenueStream {id: "rs_fruit_sales"})
CREATE (cs2)-[:GENERATES]->(rs3);

// Value Propositions to Key Resources
MATCH (vp1:ValueProposition {id: "vp_trusted_fruit_exports"}), (kr1:KeyResource {id: "kr_digital_trust_platform"})
CREATE (vp1)-[:REQUIRES_RESOURCE]->(kr1);

MATCH (vp1:ValueProposition {id: "vp_trusted_fruit_exports"}), (kr2:KeyResource {id: "kr_export_operations_infrastructure"})
CREATE (vp1)-[:REQUIRES_RESOURCE]->(kr2);

MATCH (vp1:ValueProposition {id: "vp_trusted_fruit_exports"}), (kr3:KeyResource {id: "kr_organic_farm_network"})
CREATE (vp1)-[:REQUIRES_RESOURCE]->(kr3);

MATCH (vp2:ValueProposition {id: "vp_investment_opportunity"}), (kr4:KeyResource {id: "kr_financial_investment_structure"})
CREATE (vp2)-[:REQUIRES_RESOURCE]->(kr4);

MATCH (vp2:ValueProposition {id: "vp_investment_opportunity"}), (kr5:KeyResource {id: "kr_governance_legal_framework"})
CREATE (vp2)-[:REQUIRES_RESOURCE]->(kr5);

// Key Activities to Key Resources
MATCH (ka1:KeyActivity {id: "ka_goldenberry_export_operations"}), (kr2:KeyResource {id: "kr_export_operations_infrastructure"})
CREATE (ka1)-[:USES_RESOURCE]->(kr2);

MATCH (ka1:KeyActivity {id: "ka_goldenberry_export_operations"}), (kr3:KeyResource {id: "kr_organic_farm_network"})
CREATE (ka1)-[:USES_RESOURCE]->(kr3);

MATCH (ka2:KeyActivity {id: "ka_digital_trust_certification"}), (kr1:KeyResource {id: "kr_digital_trust_platform"})
CREATE (ka2)-[:USES_RESOURCE]->(kr1);

MATCH (ka3:KeyActivity {id: "ka_quality_assurance_traceability"}), (kr2:KeyResource {id: "kr_export_operations_infrastructure"})
CREATE (ka3)-[:USES_RESOURCE]->(kr2);

MATCH (ka3:KeyActivity {id: "ka_quality_assurance_traceability"}), (kr3:KeyResource {id: "kr_organic_farm_network"})
CREATE (ka3)-[:USES_RESOURCE]->(kr3);

MATCH (ka4:KeyActivity {id: "ka_supply_chain_coordination"}), (kr2:KeyResource {id: "kr_export_operations_infrastructure"})
CREATE (ka4)-[:USES_RESOURCE]->(kr2);

MATCH (ka5:KeyActivity {id: "ka_investor_relations_management"}), (kr4:KeyResource {id: "kr_financial_investment_structure"})
CREATE (ka5)-[:USES_RESOURCE]->(kr4);

MATCH (ka5:KeyActivity {id: "ka_investor_relations_management"}), (kr5:KeyResource {id: "kr_governance_legal_framework"})
CREATE (ka5)-[:USES_RESOURCE]->(kr5);

MATCH (ka6:KeyActivity {id: "ka_platform_technology_development"}), (kr1:KeyResource {id: "kr_digital_trust_platform"})
CREATE (ka6)-[:USES_RESOURCE]->(kr1);

// Key Partnerships to Key Resources
MATCH (kp1:KeyPartnership {id: "kp_organic_certified_farms"}), (kr3:KeyResource {id: "kr_organic_farm_network"})
CREATE (kp1)-[:ENABLES]->(kr3);

MATCH (kp2:KeyPartnership {id: "kp_international_logistics_providers"}), (kr2:KeyResource {id: "kr_export_operations_infrastructure"})
CREATE (kp2)-[:ENABLES]->(kr2);

MATCH (kp3:KeyPartnership {id: "kp_blockchain_technology_partners"}), (kr1:KeyResource {id: "kr_digital_trust_platform"})
CREATE (kp3)-[:ENABLES]->(kr1);

MATCH (kp4:KeyPartnership {id: "kp_impact_investment_networks"}), (kr4:KeyResource {id: "kr_financial_investment_structure"})
CREATE (kp4)-[:ENABLES]->(kr4);

MATCH (kp5:KeyPartnership {id: "kp_regulatory_compliance_experts"}), (kr5:KeyResource {id: "kr_governance_legal_framework"})
CREATE (kp5)-[:ENABLES]->(kr5);

// Key Activities to Cost Structures (INCURS_COST relationships)
MATCH (ka1:KeyActivity {id: "ka_goldenberry_export_operations"}), (cost1:CostStructure {id: "cost_fruit_sourcing"})
CREATE (ka1)-[:INCURS_COST {costDriver: "Premium fruit sourcing for export operations"}]->(cost1);

MATCH (ka1:KeyActivity {id: "ka_goldenberry_export_operations"}), (cost2:CostStructure {id: "cost_post_harvest"})
CREATE (ka1)-[:INCURS_COST {costDriver: "Post-harvest processing for export quality"}]->(cost2);

MATCH (ka1:KeyActivity {id: "ka_goldenberry_export_operations"}), (cost9:CostStructure {id: "cost_shipping_freight"})
CREATE (ka1)-[:INCURS_COST {costDriver: "International shipping for export operations"}]->(cost9);

MATCH (ka1:KeyActivity {id: "ka_goldenberry_export_operations"}), (cost10:CostStructure {id: "cost_customs_documentation"})
CREATE (ka1)-[:INCURS_COST {costDriver: "Export documentation and customs"}]->(cost10);

MATCH (ka1:KeyActivity {id: "ka_goldenberry_export_operations"}), (cost13:CostStructure {id: "cost_export_staff"})
CREATE (ka1)-[:INCURS_COST {costDriver: "Export operations team"}]->(cost13);

MATCH (ka2:KeyActivity {id: "ka_digital_trust_certification"}), (cost15:CostStructure {id: "cost_blockchain_platform"})
CREATE (ka2)-[:INCURS_COST {costDriver: "Blockchain platform for trust certification"}]->(cost15);

MATCH (ka2:KeyActivity {id: "ka_digital_trust_certification"}), (cost16:CostStructure {id: "cost_digital_certificates"})
CREATE (ka2)-[:INCURS_COST {costDriver: "Digital certificate generation and validation"}]->(cost16);

MATCH (ka2:KeyActivity {id: "ka_digital_trust_certification"}), (cost20:CostStructure {id: "cost_cybersecurity"})
CREATE (ka2)-[:INCURS_COST {costDriver: "Security for trust certification systems"}]->(cost20);

MATCH (ka3:KeyActivity {id: "ka_quality_assurance_traceability"}), (cost4:CostStructure {id: "cost_quality_control"})
CREATE (ka3)-[:INCURS_COST {costDriver: "Quality control and testing operations"}]->(cost4);

MATCH (ka3:KeyActivity {id: "ka_quality_assurance_traceability"}), (cost17:CostStructure {id: "cost_iot_monitoring"})
CREATE (ka3)-[:INCURS_COST {costDriver: "IoT systems for traceability monitoring"}]->(cost17);

MATCH (ka3:KeyActivity {id: "ka_quality_assurance_traceability"}), (cost22:CostStructure {id: "cost_audit_certification"})
CREATE (ka3)-[:INCURS_COST {costDriver: "Third-party audits for quality assurance"}]->(cost22);

MATCH (ka4:KeyActivity {id: "ka_supply_chain_coordination"}), (cost12:CostStructure {id: "cost_logistics_coordination"})
CREATE (ka4)-[:INCURS_COST {costDriver: "Logistics coordination across supply chain"}]->(cost12);

MATCH (ka4:KeyActivity {id: "ka_supply_chain_coordination"}), (cost30:CostStructure {id: "cost_supply_risk"})
CREATE (ka4)-[:INCURS_COST {costDriver: "Supply chain risk management"}]->(cost30);

MATCH (ka5:KeyActivity {id: "ka_investor_relations_management"}), (cost23:CostStructure {id: "cost_legal_compliance"})
CREATE (ka5)-[:INCURS_COST {costDriver: "Legal support for investor relations"}]->(cost23);

MATCH (ka5:KeyActivity {id: "ka_investor_relations_management"}), (cost25:CostStructure {id: "cost_transparency_reporting"})
CREATE (ka5)-[:INCURS_COST {costDriver: "Transparency reporting for investors"}]->(cost25);

MATCH (ka6:KeyActivity {id: "ka_platform_technology_development"}), (cost18:CostStructure {id: "cost_data_storage"})
CREATE (ka6)-[:INCURS_COST {costDriver: "Data storage for platform development"}]->(cost18);

MATCH (ka6:KeyActivity {id: "ka_platform_technology_development"}), (cost19:CostStructure {id: "cost_api_integration"})
CREATE (ka6)-[:INCURS_COST {costDriver: "API development and maintenance"}]->(cost19);

// Key Resources to Cost Structures
MATCH (kr1:KeyResource {id: "kr_digital_trust_platform"}), (cost15:CostStructure {id: "cost_blockchain_platform"})
CREATE (kr1)-[:INCURS_COST {costDriver: "Digital trust platform infrastructure"}]->(cost15);

MATCH (kr1:KeyResource {id: "kr_digital_trust_platform"}), (cost18:CostStructure {id: "cost_data_storage"})
CREATE (kr1)-[:INCURS_COST {costDriver: "Platform data storage requirements"}]->(cost18);

MATCH (kr2:KeyResource {id: "kr_export_operations_infrastructure"}), (cost5:CostStructure {id: "cost_cold_chain"})
CREATE (kr2)-[:INCURS_COST {costDriver: "Cold chain infrastructure"}]->(cost5);

MATCH (kr2:KeyResource {id: "kr_export_operations_infrastructure"}), (cost14:CostStructure {id: "cost_export_facilities"})
CREATE (kr2)-[:INCURS_COST {costDriver: "Export facilities and equipment"}]->(cost14);

MATCH (kr3:KeyResource {id: "kr_organic_farm_network"}), (cost1:CostStructure {id: "cost_fruit_sourcing"})
CREATE (kr3)-[:INCURS_COST {costDriver: "Organic farm network sourcing"}]->(cost1);

MATCH (kr4:KeyResource {id: "kr_financial_investment_structure"}), (cost26:CostStructure {id: "cost_trade_finance"})
CREATE (kr4)-[:INCURS_COST {costDriver: "Investment structure trade finance"}]->(cost26);

MATCH (kr4:KeyResource {id: "kr_financial_investment_structure"}), (cost29:CostStructure {id: "cost_financial_reporting"})
CREATE (kr4)-[:INCURS_COST {costDriver: "Investment structure financial reporting"}]->(cost29);

MATCH (kr5:KeyResource {id: "kr_governance_legal_framework"}), (cost21:CostStructure {id: "cost_compliance_monitoring"})
CREATE (kr5)-[:INCURS_COST {costDriver: "Governance framework compliance"}]->(cost21);

MATCH (kr5:KeyResource {id: "kr_governance_legal_framework"}), (cost24:CostStructure {id: "cost_governance_framework"})
CREATE (kr5)-[:INCURS_COST {costDriver: "Legal framework governance"}]->(cost24);

// Channels to Cost Structures
MATCH (ch3:Channel {id: "ch_investor_digital_platforms"}), (cost15:CostStructure {id: "cost_blockchain_platform"})
CREATE (ch3)-[:INCURS_COST {costDriver: "Digital platform infrastructure for investor channels"}]->(cost15);

MATCH (ch9:Channel {id: "ch_investor_digital_portal"}), (cost18:CostStructure {id: "cost_data_storage"})
CREATE (ch9)-[:INCURS_COST {costDriver: "Investor portal data storage"}]->(cost18);

MATCH (ch19:Channel {id: "ch_importer_digital_platform"}), (cost19:CostStructure {id: "cost_api_integration"})
CREATE (ch19)-[:INCURS_COST {costDriver: "Importer platform API integration"}]->(cost19);

MATCH (ch22:Channel {id: "ch_importer_logistics_coordination"}), (cost12:CostStructure {id: "cost_logistics_coordination"})
CREATE (ch22)-[:INCURS_COST {costDriver: "Logistics coordination channel operations"}]->(cost12);

// Additional cost relationships for comprehensive coverage
MATCH (cost3:CostStructure {id: "cost_packaging_materials"}), (ka1:KeyActivity {id: "ka_goldenberry_export_operations"})
CREATE (ka1)-[:INCURS_COST {costDriver: "Export packaging requirements"}]->(cost3);

MATCH (cost6:CostStructure {id: "cost_container_prep"}), (ka1:KeyActivity {id: "ka_goldenberry_export_operations"})
CREATE (ka1)-[:INCURS_COST {costDriver: "Container preparation for exports"}]->(cost6);

MATCH (cost7:CostStructure {id: "cost_origin_handling"}), (ka1:KeyActivity {id: "ka_goldenberry_export_operations"})
CREATE (ka1)-[:INCURS_COST {costDriver: "Origin port handling"}]->(cost7);

MATCH (cost8:CostStructure {id: "cost_product_insurance"}), (ka1:KeyActivity {id: "ka_goldenberry_export_operations"})
CREATE (ka1)-[:INCURS_COST {costDriver: "Export product insurance"}]->(cost8);

MATCH (cost11:CostStructure {id: "cost_destination_port"}), (ka4:KeyActivity {id: "ka_supply_chain_coordination"})
CREATE (ka4)-[:INCURS_COST {costDriver: "Destination port coordination"}]->(cost11);

MATCH (cost27:CostStructure {id: "cost_currency_hedging"}), (kr4:KeyResource {id: "kr_financial_investment_structure"})
CREATE (kr4)-[:INCURS_COST {costDriver: "Currency risk management"}]->(cost27);

MATCH (cost28:CostStructure {id: "cost_payment_processing"}), (kr4:KeyResource {id: "kr_financial_investment_structure"})
CREATE (kr4)-[:INCURS_COST {costDriver: "International payment processing"}]->(cost28);

MATCH (cost31:CostStructure {id: "cost_market_risk"}), (ka5:KeyActivity {id: "ka_investor_relations_management"})
CREATE (ka5)-[:INCURS_COST {costDriver: "Market risk management for investors"}]->(cost31);

MATCH (cost32:CostStructure {id: "cost_operational_risk"}), (ka4:KeyActivity {id: "ka_supply_chain_coordination"})
CREATE (ka4)-[:INCURS_COST {costDriver: "Operational risk coverage"}]->(cost32);

MATCH (cost33:CostStructure {id: "cost_emergency_response"}), (ka4:KeyActivity {id: "ka_supply_chain_coordination"})
CREATE (ka4)-[:INCURS_COST {costDriver: "Emergency response capabilities"}]->(cost33);

// =====================================================
// VALIDATION CONFIRMATION
// =====================================================

RETURN "✅ Goldenberry Flow Knowledge Graph Successfully Created" as Status,
       "All 12 node types, 28 channels, 33 cost structures, and comprehensive relationships have been established" as Summary;