serve:
	jekyll serve --watch

index: page.head README.md
		cat page.head README.md > index.md
