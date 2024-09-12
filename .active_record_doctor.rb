ActiveRecordDoctor.configure do
  # Global settings affect all detectors.
  global :ignore_models, [
    "SolidQueue::Semaphore",
    "SolidQueue::BlockedExecution",
    "SolidQueue::Job",
    "SolidQueue::Pause",
    "SolidQueue::Process",
    "SolidQueue::ReadyExecution",
    "SolidQueue::RecurringExecution",
    "SolidQueue::ScheduledExecution",
    "SolidQueue::BlockedExecution",
    "SolidQueue::ClaimedExecution",
    "SolidQueue::FailedExecution",
    "SolidQueue::RecurringTask",
    "ActionText::RichText",
    "ActionText::EncryptedRichText",
    "ActiveStorage::VariantRecord",
    "ActiveStorage::Blob",
    "ActiveStorage::Attachment",
    "ActionMailbox::InboundEmail"
  ]
  global :ignore_tables, [
    "ar_internal_metadata",
    "schema_migrations",
    /^solid_queue/
  ]
end
