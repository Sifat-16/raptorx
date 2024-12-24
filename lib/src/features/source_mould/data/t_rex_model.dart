import 'package:raptorx/src/core/enum/DirectoryInstanceType.dart';
import 'package:uuid/uuid.dart';

class TRexModel {
  String id = const Uuid().v4();
  DirectoryInstanceType directoryInstanceType;
  String? name;
  String? content;
  String? copyLocation; // New field for MEDIAFILE type
  List<TRexModel>?
      tRexModel; // Changed to a List since it's an array in the JSON

  TRexModel({
    this.directoryInstanceType = DirectoryInstanceType.FOLDER,
    this.name,
    this.content,
    this.copyLocation,
    this.tRexModel,
  });

  factory TRexModel.fromJson(Map<String, dynamic> json) {
    DirectoryInstanceType directoryInstanceType = DirectoryInstanceType.values
        .firstWhere((e) =>
            e.toString().split('.').last == json['directoryInstanceType']);

    List<TRexModel>? tRexModelList;
    if (json['tRexModel'] != null) {
      tRexModelList = List<TRexModel>.from(
        json['tRexModel'].map((x) => TRexModel.fromJson(x)),
      );
    }

    return TRexModel(
      directoryInstanceType: directoryInstanceType,
      name: json['name'],
      content: json['content'],
      copyLocation: json['copyLocation'], // Handle copyLocation from JSON
      tRexModel: tRexModelList,
    );
  }

  /// Method to create a new folder or file inside a parent node
  TRexModel? createNewTRexInsideParent({
    required TRexModel newModel,
    required String parentId,
  }) {
    // Check if the current node is the parent
    if (id == parentId) {
      // Initialize the children list if null
      tRexModel ??= [];

      // Add the new folder or file
      tRexModel!.add(newModel);

      // Return the updated tree
      return this;
    }

    // If the current node has children, try to find the parent recursively
    if (tRexModel != null) {
      for (var child in tRexModel!) {
        final updatedTree = child.createNewTRexInsideParent(
          newModel: newModel,
          parentId: parentId,
        );

        if (updatedTree != null) {
          return this; // Return the updated tree
        }
      }
    }

    // Return null if the parent was not found in the subtree
    return null;
  }

  /// Deletes a resource from the tree based on its id.
  /// Returns the updated tree if successful, or `null` if the id is not found.
  TRexModel? deleteResource({required String resourceId}) {
    // If the current node has children, search recursively in the children
    if (tRexModel != null) {
      for (int i = 0; i < tRexModel!.length; i++) {
        // Check if the child node matches the resourceId
        if (tRexModel![i].id == resourceId) {
          tRexModel!.removeAt(i); // Remove the node
          return this; // Return the updated tree
        }

        // Recursively search in the child node's children
        final updatedTree =
            tRexModel![i].deleteResource(resourceId: resourceId);
        if (updatedTree != null) {
          return this; // Return the updated tree if the resource is found
        }
      }
    }

    // Return null if the resourceId is not found in this subtree
    return null;
  }

  /// Updates the tree by finding the node with the same `id` as the passed `updatedModel`
  /// and replacing it with the `updatedModel`.
  /// Returns the updated `TRexModel` (tree) if successful, or null if not found.
  TRexModel? updateChildTRexModel(
      {required TRexModel parentModel, required TRexModel updatedModel}) {
    // If the parent contains children
    if (parentModel.tRexModel != null) {
      for (int i = 0; i < parentModel.tRexModel!.length; i++) {
        // Check if the current child matches the ID of the updated model
        if (parentModel.tRexModel![i].id == updatedModel.id) {
          // Replace the child with the updated model
          parentModel.tRexModel![i] = updatedModel;
          return parentModel; // Return the updated parent model
        } else {
          // Recursive call to update deeper nodes
          TRexModel? updatedSubTree = updateChildTRexModel(
              parentModel: parentModel.tRexModel![i],
              updatedModel: updatedModel);
          if (updatedSubTree != null) {
            parentModel.tRexModel![i] = updatedSubTree; // Update the child tree
            return parentModel; // Return the updated parent model
          }
        }
      }
    }

    // Return null if the ID was not found in this subtree
    return null;
  }

  bool checkDuplicate(
      {required String parentId,
      required TRexModel child,
      required TRexModel root}) {
    // Find the parent node
    TRexModel? parent = _findParentById(root, parentId);

    // If parent is not found, return false (no duplicates)
    if (parent == null) {
      return false;
    }

    // Check if any child of the parent has the same name and directoryInstanceType
    if (parent.tRexModel != null) {
      for (TRexModel existingChild in parent.tRexModel!) {
        if (existingChild.name == child.name &&
            existingChild.directoryInstanceType ==
                child.directoryInstanceType) {
          return true; // Duplicate found
        }
      }
    }

    return false; // No duplicates
  }

// Helper function to find a node by its ID
  TRexModel? _findParentById(TRexModel node, String id) {
    if (node.id == id) {
      return node;
    }

    if (node.tRexModel != null) {
      for (TRexModel child in node.tRexModel!) {
        TRexModel? found = _findParentById(child, id);
        if (found != null) {
          return found;
        }
      }
    }

    return null; // Not found
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'directoryInstanceType': directoryInstanceType.toString().split('.').last,
      'name': name,
      'content': content,
      'copyLocation': copyLocation, // Include copyLocation in JSON
      'tRexModel': tRexModel?.map((child) => child.toJson()).toList(),
    };
  }
}
