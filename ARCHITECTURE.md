# CKRetz System Architecture

This document describes the system architecture of the CKRetz secrets management application.

## System Architecture Diagrams

The following diagrams break down the system architecture into focused views by layer and concern.

### 1. Client & Presentation Layer

This diagram shows how users interact with the application through browsers and APIs, and how requests flow through controllers to views.

```mermaid
graph TB
    subgraph "Client Layer"
        Browser[Browser<br/>Hotwire + Stimulus + Tailwind]
        OAuth[Google OAuth2]
        ChatbotClient[Chatbot Client<br/>JWT Token]
    end

    subgraph "Presentation Layer"
        Controllers[Controllers]
        SecretsCtrl[SecretsController<br/>CRUD, Search, Pagination]
        AccessTokensCtrl[AccessTokensController<br/>API Token Management]
        OmniauthCtrl[OmniauthController<br/>OAuth2 Flows]
        UsersCtrl[UsersController<br/>Authentication]
        AdminCtrl[AdminController<br/>Mission Control Jobs]

        Views[Views<br/>ERB + Tailwind CSS]

        HotwireComponents[Hotwire Components]
        TurboStreams[Turbo Streams<br/>Real-time Updates]
        StimulusJS[Stimulus Controllers<br/>Interactivity]
    end

    %% Client connections
    Browser --> Controllers
    OAuth --> OmniauthCtrl
    ChatbotClient --> Controllers

    %% Controller layer
    Controllers --> SecretsCtrl
    Controllers --> AccessTokensCtrl
    Controllers --> OmniauthCtrl
    Controllers --> UsersCtrl
    Controllers --> AdminCtrl
    Controllers --> Views
    Controllers --> HotwireComponents
    HotwireComponents --> TurboStreams
    HotwireComponents --> StimulusJS

    classDef clientClass fill:#e1f5ff,stroke:#01579b,stroke-width:2px
    classDef presentationClass fill:#f3e5f5,stroke:#4a148c,stroke-width:2px

    class Browser,OAuth,ChatbotClient clientClass
    class Controllers,SecretsCtrl,AccessTokensCtrl,OmniauthCtrl,UsersCtrl,AdminCtrl,Views,HotwireComponents,TurboStreams,StimulusJS presentationClass
```

### 2. Application Logic & Authentication

This diagram illustrates the CQRS pattern, authentication mechanisms, and how business logic is organized.

```mermaid
graph TB
    subgraph "Controllers"
        SecretsCtrl[SecretsController]
        UsersCtrl[UsersController]
        OmniauthCtrl[OmniauthController]
    end

    subgraph "CQRS Pattern"
        Queries[Queries::Secrets::Index<br/>Search, Filter, Sort]
        Commands[Commands::Users::Create]
        CommandHandlers[CommandHandlers::Users::Create]
    end

    subgraph "Controller Concerns"
        CurrentUser[CurrentUser<br/>Session/Token Auth]
        ExceptionHandler[ExceptionHandler]
        WithProsopite[WithProsopite<br/>N+1 Detection]
    end

    subgraph "Authentication & Authorization"
        OmniAuthProvider[OmniAuth<br/>Google, Developer]
        BearerToken[Bearer Token Validation]
        JWTToken[JWT Token Validation<br/>Chatbot]
        RLSEnforcement[RLS Enforcement<br/>Database-level]
    end

    %% Flow connections
    SecretsCtrl --> Queries
    SecretsCtrl --> CurrentUser
    UsersCtrl --> Commands
    Commands --> CommandHandlers

    OmniauthCtrl --> OmniAuthProvider
    CurrentUser --> BearerToken
    CurrentUser --> JWTToken
    CurrentUser --> RLSEnforcement

    classDef logicClass fill:#fff3e0,stroke:#e65100,stroke-width:2px
    classDef authClass fill:#ffe0b2,stroke:#e65100,stroke-width:2px

    class Queries,Commands,CommandHandlers,CurrentUser,ExceptionHandler,WithProsopite logicClass
    class OmniAuthProvider,BearerToken,JWTToken,RLSEnforcement authClass
```

### 3. Data & Database Layer

This diagram shows the data models, their relationships, and the multi-database PostgreSQL setup.

```mermaid
graph TB
    subgraph "ActiveRecord Models"
        UserModel[User<br/>• Encrypted Email<br/>• Counter Cache<br/>• has_many :secrets<br/>• has_many :access_tokens]
        SecretModel[Secret<br/>• pgvector Embeddings<br/>• Full-text Search<br/>• belongs_to :user<br/>• has_many :secret_values]
        SecretValueModel[SecretValue<br/>• Key-Value Pairs<br/>• belongs_to :secret]
        AccessTokenModel[AccessToken<br/>• Encrypted Token<br/>• belongs_to :user]
    end

    subgraph "Primary Database - PostgreSQL 16"
        PrimaryDB[(ckretz_primary_*)]
        UsersTable[users table]
        SecretsTable[secrets table<br/>embedding:vector 768]
        SecretValuesTable[secret_values table]
        AccessTokensTable[access_tokens table]
    end

    subgraph "Supporting Databases"
        CacheDB[(Cache DB<br/>ckretz_cache_*<br/>Solid Cache)]
        QueueDB[(Queue DB<br/>ckretz_queue_*<br/>Solid Queue)]
        CableDB[(Cable DB<br/>ckretz_cable_*<br/>Solid Cable)]
    end

    subgraph "Database Features"
        DBFeatures[• UUID Primary Keys<br/>• Row-Level Security<br/>• pgvector HNSW Index<br/>• Full-text Search<br/>• Active Record Encryption<br/>• pg_stat_statements]
    end

    %% Model to Table connections
    UserModel --> UsersTable
    SecretModel --> SecretsTable
    SecretValueModel --> SecretValuesTable
    AccessTokenModel --> AccessTokensTable

    %% Table to DB connections
    UsersTable --> PrimaryDB
    SecretsTable --> PrimaryDB
    SecretValuesTable --> PrimaryDB
    AccessTokensTable --> PrimaryDB

    PrimaryDB --> DBFeatures

    classDef modelClass fill:#e8f5e9,stroke:#1b5e20,stroke-width:2px
    classDef dbClass fill:#fce4ec,stroke:#880e4f,stroke-width:2px

    class UserModel,SecretModel,SecretValueModel,AccessTokenModel modelClass
    class PrimaryDB,CacheDB,QueueDB,CableDB,UsersTable,SecretsTable,SecretValuesTable,AccessTokensTable,DBFeatures dbClass
```

### 4. Background Jobs & Events

This diagram depicts the event-driven architecture and asynchronous job processing.

```mermaid
graph TB
    subgraph "Models with Events"
        SecretModel[Secret Model]
        UserModel[User Model]
    end

    subgraph "Event System"
        Events[ActiveSupport::Notifications]
        SecretSubscriber[SecretSubscriber<br/>• created.secret<br/>• updated.secret]
        WelcomeSubscriber[WelcomeEmailSubscriber<br/>• created.user]
        SlowQuerySubscriber[SlowQuerySubscriber<br/>• sql.active_record]
    end

    subgraph "Background Jobs"
        SolidQueue[Solid Queue<br/>Database-backed<br/>3 threads/process]
        EmbedJob[EmbedSecretJob<br/>Generate Vector Embeddings]
        QueueDB[(Queue DB)]
    end

    subgraph "Mailers"
        UserMailer[UserMailer<br/>Welcome Email]
    end

    subgraph "Real-time Broadcasting"
        TurboStreams[Turbo Streams<br/>• broadcast_prepend_to<br/>• broadcast_replace_to<br/>• broadcast_remove_to]
        CableDB[(Cable DB<br/>Solid Cable)]
    end

    %% Event flow
    SecretModel -.->|after_create_commit| Events
    UserModel -.->|after_create_commit| Events

    Events --> SecretSubscriber
    Events --> WelcomeSubscriber
    Events --> SlowQuerySubscriber

    SecretSubscriber --> EmbedJob
    WelcomeSubscriber --> UserMailer

    EmbedJob --> SolidQueue
    SolidQueue --> QueueDB

    %% Real-time updates
    SecretModel -.->|after_commit| TurboStreams
    TurboStreams --> CableDB

    classDef asyncClass fill:#fff9c4,stroke:#f57f17,stroke-width:2px
    classDef eventClass fill:#fff3e0,stroke:#e65100,stroke-width:2px

    class SolidQueue,EmbedJob,UserMailer,TurboStreams asyncClass
    class Events,SecretSubscriber,WelcomeSubscriber,SlowQuerySubscriber eventClass
```

### 5. External Services Integration

This diagram shows all external service dependencies and their integration points.

```mermaid
graph TB
    subgraph "Application Components"
        OmniauthCtrl[OmniauthController]
        EmbedJob[EmbedSecretJob]
        SecretsCtrl[SecretsController]
        UserMailer[UserMailer]
        Controllers[All Controllers]
        Models[All Models]
    end

    subgraph "External Services"
        GoogleOAuth[Google OAuth2<br/>Authentication]
        OllamaAPI[Ollama API<br/>• nomic-embed-text<br/>• 768-dim Embeddings]
        OpenFeature[OpenFeature/Flagd<br/>Feature Flags]
        Mailtrap[Mailtrap<br/>Email Delivery Dev]
        OpenTelemetry[OpenTelemetry<br/>Distributed Tracing<br/>Production]
        Fluentd[Fluentd<br/>Log Aggregation<br/>Optional]
    end

    %% Service connections
    OmniauthCtrl --> GoogleOAuth
    EmbedJob --> OllamaAPI
    SecretsCtrl --> OpenFeature
    UserMailer --> Mailtrap
    Controllers -.->|tracing| OpenTelemetry
    Models -.->|logs| Fluentd

    classDef externalClass fill:#e0f2f1,stroke:#004d40,stroke-width:2px
    classDef appClass fill:#f3e5f5,stroke:#4a148c,stroke-width:2px

    class GoogleOAuth,OllamaAPI,OpenFeature,Mailtrap,OpenTelemetry,Fluentd externalClass
    class OmniauthCtrl,EmbedJob,SecretsCtrl,UserMailer,Controllers,Models appClass
```

### 6. Infrastructure & Deployment

This diagram illustrates the CI/CD pipeline and deployment infrastructure.

```mermaid
graph TB
    subgraph "Development"
        DevEnv[Devbox Environment<br/>• PostgreSQL 16<br/>• Ruby 3.3.5+<br/>• Git, Go Task]
        LocalDocker[Local Docker Build<br/>ruby:3.3.10-slim]
    end

    subgraph "CI/CD Pipeline - GitHub Actions"
        SecurityScan[Security Scanning<br/>• Brakeman<br/>• Importmap Audit]
        CodeQuality[Code Quality<br/>• Rubocop Lint]
        Testing[Testing<br/>• RSpec Tests<br/>• PostgreSQL Service<br/>• Coverage Report]
        AssetBuild[Asset Build<br/>• Precompilation<br/>• Propshaft]
        DockerBuild[Docker Build<br/>• Multi-stage Build<br/>• amd64 Architecture<br/>• Non-root User]
    end

    subgraph "Container Registry"
        DockerHub[Docker Hub<br/>ckretz-org/ckretz<br/>Tag: commit SHA]
    end

    subgraph "Deployment"
        FluxCD[FluxCD<br/>GitOps Deployment]
        HelmRepo[Helm Repository<br/>ckretz-helm-production]
        Dagger[Dagger Pipeline<br/>Go-based Orchestration]
    end

    %% Flow
    DevEnv --> LocalDocker
    LocalDocker --> SecurityScan
    SecurityScan --> CodeQuality
    CodeQuality --> Testing
    Testing --> AssetBuild
    AssetBuild --> DockerBuild
    DockerBuild --> DockerHub
    DockerHub --> FluxCD
    FluxCD --> HelmRepo

    Dagger -.->|orchestrates| DockerBuild

    classDef infraClass fill:#efebe9,stroke:#3e2723,stroke-width:2px
    classDef ciClass fill:#e3f2fd,stroke:#01579b,stroke-width:2px

    class DevEnv,LocalDocker,DockerHub,FluxCD,HelmRepo,Dagger infraClass
    class SecurityScan,CodeQuality,Testing,AssetBuild,DockerBuild ciClass
```

## Overview

CKRetz is a modern **Ruby on Rails 8.1** secrets management application featuring:

- **Multi-database PostgreSQL setup** with separate databases for primary data, cache, queue, and WebSocket communications
- **Vector embeddings** using pgvector for semantic search (768-dimensional)
- **Row-Level Security (RLS)** for database-enforced multi-tenancy
- **Event-driven architecture** with ActiveSupport::Notifications
- **Real-time updates** via Hotwire (Turbo Streams + Stimulus)
- **CQRS pattern** for separating reads and writes
- **Modern Rails stack** with Solid Queue, Solid Cache, and Solid Cable

## Technology Stack

### Backend
- **Ruby 3.3.10**
- **Rails 8.1**
- **Puma 6** - Web server
- **PostgreSQL 16** with extensions:
  - pgvector - Vector similarity search
  - pgcrypto - UUID generation
  - citext - Case-insensitive text
  - pg_stat_statements - Query performance analysis

### Frontend
- **Hotwire** (Turbo + Stimulus)
- **Tailwind CSS 3.0**
- **Propshaft** - Asset pipeline
- **Importmap Rails** - JavaScript module loading

### Testing & Quality
- **RSpec** - Testing framework
- **Capybara** - Integration testing
- **SimpleCov** - Code coverage
- **Rubocop** - Code linting
- **Brakeman** - Security scanning

## Database Architecture

The application uses **4 separate PostgreSQL databases**:

1. **Primary Database** (`ckretz_primary_*`)
   - Main application data (Users, Secrets, SecretValues, AccessTokens)
   - UUID primary keys
   - Row-Level Security (RLS) policies
   - pgvector embeddings (768-dimensional)
   - Full-text search capabilities

2. **Cache Database** (`ckretz_cache_*`)
   - Solid Cache storage
   - Database-backed caching

3. **Queue Database** (`ckretz_queue_*`)
   - Solid Queue job persistence
   - Background job processing

4. **Cable Database** (`ckretz_cable_*`)
   - Solid Cable WebSocket storage
   - Real-time communication

## Key Components

### Models & Data Layer

```
User (has_many: secrets, access_tokens, secret_values)
  └── Secret (belongs_to: user, has_many: secret_values)
      └── SecretValue (belongs_to: secret)
  └── AccessToken (belongs_to: user)
```

**Features:**
- Counter caches for performance
- Dependent destruction (cascade delete)
- Vector embeddings for semantic search
- Full-text search using PG Search
- Active Record encryption for sensitive fields

### Controllers & Presentation

- `SecretsController` - CRUD operations, search, pagination, sorting
- `AccessTokensController` - API token management
- `OmniauthController` - OAuth2 authentication (Google, developer)
- `UsersController` - User authentication and welcome
- `AdminController` - Admin panel (Mission Control Jobs)

### Authentication & Authorization

- **OmniAuth** - Google OAuth2 and developer provider
- **Session-based** - Rails session cookies
- **Bearer tokens** - Access tokens for API authentication
- **JWT Tokens** - For chatbot integration
- **Row-Level Security** - Database-enforced user isolation via `rls_rails` gem

### CQRS Pattern

**Queries:**
- `Queries::Secrets::Index` - Complex secret filtering and search

**Commands:**
- `Commands::Users::Create` - User creation command
- `CommandHandlers::Users::Create` - Command execution

## Background Jobs & Events

### Job Queue
- **Solid Queue** - Database-backed job queue
- 3 threads per process, configurable via `JOB_CONCURRENCY`
- `EmbedSecretJob` - Generates vector embeddings via Ollama API

### Event System (ActiveSupport::Notifications)

**Event Subscribers:**
1. `SecretSubscriber` - Triggers embedding generation on secret create/update
2. `WelcomeEmailSubscriber` - Sends welcome email on user registration
3. `SlowQuerySubscriber` - Logs slow database queries (dev only)

## Real-Time Features

### Hotwire Integration
- **Turbo Streams** - Server-sent DOM updates
  - `broadcast_prepend_to "secrets"` - New secrets
  - `broadcast_replace_to "secrets"` - Secret updates
  - `broadcast_remove_to "secrets"` - Secret deletion

- **Solid Cable** - Production WebSocket adapter
  - Database-backed message storage
  - 1-day message retention
  - 0.1s polling interval

## External Service Integrations

1. **Google OAuth2** - User authentication
2. **Ollama API** - AI embeddings (nomic-embed-text model, 768-dim)
3. **OpenFeature/Flagd** - Feature flag management
4. **Mailtrap** - Email delivery (development)
5. **OpenTelemetry** - Distributed tracing (production)
6. **Fluentd** - Log aggregation (optional)

## Data Flow Examples

### Creating a Secret

```
User Form → SecretsController#create
  → Secret.create (with secret_values)
  → after_create_commit hooks:
    1. broadcast_prepend_to "secrets" (Turbo Stream)
    2. ActiveSupport::Notifications.instrument("created.secret")
       └── SecretSubscriber receives event
           └── EmbedSecretJob.perform_later
               └── Calls Ollama API
                   └── Stores embedding in pgvector column
```

### User Authentication

```
Login Form → OmniauthController#callback (OAuth)
  → Commands::Users::Create (find or create user)
  → session[:current_user_id] = user.id
  → Redirect to secrets_path

OR API Request with Token:
  → Header: "Authorization: Bearer <token>"
  → CurrentUser concern extracts token
  → AccessToken.find_by_token(token)
  → RLS policy enforces user isolation
```

### Real-Time Secret Updates

```
Secret Update → broadcast_replace_to "secrets"
  → Solid Cable broadcasts to all subscribers
  → WebSocket message sent to clients
  → JavaScript updates DOM without page reload
```

## Security Features

1. **Encryption**
   - Active Record Encryption (email, tokens)
   - Deterministic encryption for searchable fields
   - Secure key derivation

2. **Authentication**
   - OAuth2 (Google)
   - Bearer token validation
   - Session cookies
   - JWT tokens for chatbot

3. **Authorization**
   - Row-Level Security (database-enforced)
   - User data isolation via RLS policies
   - Counter caches for performance

4. **Input Validation**
   - Rails validators
   - Strong parameters
   - Nested attributes with allow_destroy

5. **Security Scanning**
   - Brakeman (vulnerability scanning)
   - Bundler-audit (dependency auditing)
   - Database consistency checks

## Infrastructure & Deployment

### Development Environment
- **Devbox** - Nix-based development environment
- PostgreSQL 16 with custom extensions
- Ruby 3.3.5+
- Git, Go Task, build tools

### CI/CD Pipeline (GitHub Actions)
1. Ruby security scanning (Brakeman)
2. JavaScript dependency scanning (Importmap audit)
3. Code linting (Rubocop)
4. RSpec test suite with PostgreSQL service
5. Asset precompilation
6. Docker image build (multi-arch: amd64)
7. Docker Hub publication
8. FluxCD deployment trigger

### Containerization
- **Docker** - Multi-stage build
- Base image: `ruby:3.3.10-slim`
- Build stage: Dependencies + gems + assets
- Runtime stage: Minimal image with non-root user
- Exposed port: 3000

### Deployment
- **FluxCD** - GitOps continuous deployment
- Target: `ckretz-org/ckretz-helm-production` Helm repository
- Automated version tagging with commit SHA

## Monitoring & Observability

### Logging
- **Lograge** - Structured logging
- **Fluentd** - Log collection (optional)
- **OpenSearch integration** - Via fluent-plugin-opensearch

### Performance Monitoring
- **Rack Mini Profiler** - Request profiling (development)
- **Prosopite** - N+1 query detection (development)
- **pg_query** - SQL parsing and analysis
- **Rails Query Log Tags** - Automatic query logging

### Health Checks
- `/up` endpoint - Rails health check
- `/api/app/info` - Application information

## Architectural Patterns

1. **Row-Level Security (RLS)** - Database-enforced multi-tenancy
2. **Event-Driven Architecture** - Via ActiveSupport::Notifications
3. **CQRS Pattern** - Separate queries and commands
4. **Repository Pattern** - ActiveRecord models as repositories
5. **Dependency Injection** - Via controller concerns and service objects
6. **Real-Time Updates** - Hotwire (Turbo + Stimulus) with Solid Cable
7. **Feature Flags** - OpenFeature for gradual rollout control
8. **Encryption at Rest** - Active Record Encryption for sensitive fields

## Scalability Considerations

1. **Database Sharding Ready** - Multi-database setup supports horizontal scaling
2. **Caching** - Solid Cache with database backend
3. **Vector Search** - HNSW index on pgvector for fast similarity search
4. **Job Queue** - Solid Queue for distributed job processing
5. **Real-Time** - Solid Cable scales across multiple processes/servers
6. **Asset Pipeline** - Propshaft with digest stamping for CDN caching