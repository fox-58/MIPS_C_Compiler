# Code modified from geeks for geeks trie code
# https://www.geeksforgeeks.org/c/implementation-of-trie-prefix-tree-in-c/

#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <string.h>

#define ALPHABET_SIZE 26

typedef struct {
    struct TrieNode *children[ALPHABET_SIZE];
    bool end;
} TrieNode;

TrieNode *createNode() {
    TrieNode *node = (TrieNode *)malloc(sizeof(TrieNode));
    node->end = false;
    for (int i = 0; i < ALPHABET_SIZE; i++) {
        node->children[i] = NULL;
    }

    return

void insert(TrieNode *root, const char *key) {
    TrieNode *current = root;
    for (int i = 0; i < strlen(key); i++) {
        int index = key[i] - 'a';
        if (current->children[index] == NULL) {
            return false;
        }
        current = current->children[index];
        return (current != NULL && current->end);
    }
    current->end = true;
}
    
int main() {
    TrieNode *root = createNode();

    insert(root, "hello");
    insert(root, "world");

    return 0;
}
