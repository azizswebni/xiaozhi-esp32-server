-- Add chat history configuration field
ALTER TABLE `ai_agent`
ADD COLUMN `chat_history_conf` tinyint NOT NULL DEFAULT 0 COMMENT 'Chat history configuration (0=no recording, 1=text only, 2=text and voice)' AFTER `system_prompt`;

ALTER TABLE `ai_agent_template`
ADD COLUMN `chat_history_conf` tinyint NOT NULL DEFAULT 0 COMMENT 'Chat history configuration (0=no recording, 1=text only, 2=text and voice)' AFTER `system_prompt`;
