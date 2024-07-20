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
    "solid_queue_claimed_executions",
    "solid_queue_processes",
    "solid_queue_jobs"
  ]
end
