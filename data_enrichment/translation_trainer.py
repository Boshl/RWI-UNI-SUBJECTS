from transformers import (
    MarianMTModel,
    MarianTokenizer,
    Seq2SeqTrainer,
    Seq2SeqTrainingArguments,
    DataCollatorForSeq2Seq,
)
from datasets import load_dataset, Dataset
import pandas as pd
import torch


# preprocessing tokenization
def preprocess(example):
    input_text = example["German"]
    target_text = example["English"]
    model_input = tokenizer(
        input_text, truncation=True, padding="max_length", max_length=64
    )
    with tokenizer.as_target_tokenizer():
        labels = tokenizer(
            target_text, truncation=True, padding="max_length", max_length=64
        )
    model_input["labels"] = labels["input_ids"]
    return model_input


# loading csv file with translated examples by Destatis
df = pd.read_csv("./data_enrichment/data_input/translations_subjects.csv")
dataset = Dataset.from_pandas(df)

# model name for German to English language
model_name = "Helsinki-NLP/opus-mt-de-en"

# loading tokenizer and model here
tokenizer = MarianTokenizer.from_pretrained(model_name)
model = MarianMTModel.from_pretrained(model_name)

tokenized_dataset = dataset.map(preprocess)

# define training arguments
training_args = Seq2SeqTrainingArguments(
    output_dir="./marianmt-de-en-finetuned",
    per_device_train_batch_size=8,
    num_train_epochs=3,
    save_total_limit=2,
    save_steps=500,
    logging_steps=100,
    evaluation_strategy="no",
    fp16=True if torch.cuda.is_available() else False,
    push_to_hub=False,
)

data_collator = DataCollatorForSeq2Seq(tokenizer, model=model)

# initialize trainer
trainer = Seq2SeqTrainer(
    model=model,
    args=training_args,
    train_dataset=tokenized_dataset,
    tokenizer=tokenizer,
    data_collator=data_collator,
)

# start training based on Destatis data
trainer.train()

# save model locally
trainer.save_model("./data_enrichment/model/marianmt-de-en-finetuned")
tokenizer.save_pretrained("./data_enrichment/model/marianmt-de-en-finetuned")
